//
//  TrainingRoomAdminController.swift
//  Backend
//
//  Created by Цховребова Яна on 10.05.2025.
//

import Domain
import Vapor
import VaporToOpenAPI

public final class TrainingRoomAdminController: RouteCollection {
    private let service: ITrainingRoomService
    private let jwtMiddleware: JWTMiddleware
    private let adminRoleMiddleware: AdminRoleMiddleware
    private let roomMiddleware: TrainingRoomValidationMiddleware
    private let createMiddleware: TrainingRoomCreateValidationMiddleware
    private let nameMiddleware: TrainingRoomFindByNameValidationMiddleware
    private let capacityMiddleware:
        TrainingRoomFindByCapacityValidationMiddleware
    private let uuidMiddleware: UUIDValidationMiddleware

    public init(
        service: ITrainingRoomService,
        adminRoleMiddleware: AdminRoleMiddleware,
        jwtMiddleware: JWTMiddleware,
        roomMiddleware: TrainingRoomValidationMiddleware,
        createMiddleware: TrainingRoomCreateValidationMiddleware,
        nameMiddleware: TrainingRoomFindByNameValidationMiddleware,
        capacityMiddleware: TrainingRoomFindByCapacityValidationMiddleware,
        uuidMiddleware: UUIDValidationMiddleware
    ) {
        self.service = service
        self.adminRoleMiddleware = adminRoleMiddleware
        self.jwtMiddleware = jwtMiddleware
        self.roomMiddleware = roomMiddleware
        self.createMiddleware = createMiddleware
        self.nameMiddleware = nameMiddleware
        self.capacityMiddleware = capacityMiddleware
        self.uuidMiddleware = uuidMiddleware
    }

    public func boot(routes: RoutesBuilder) throws {
        let trainingRoomRoutes = setupRoutes(routes)
        registerGetRoutes(trainingRoomRoutes)
        registerPostRoutes(trainingRoomRoutes)
        registerPutRoutes(trainingRoomRoutes)
        registerDeleteRoutes(trainingRoomRoutes)
    }
}

// MARK: - Route Registration

extension TrainingRoomAdminController {
    fileprivate func setupRoutes(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes.grouped("admin", "training-rooms")
            .grouped(jwtMiddleware)
            .grouped(adminRoleMiddleware)
    }

    fileprivate func registerGetRoutes(_ routes: RoutesBuilder) {
        routes.get("all", use: getAllTrainingRooms)
            .openAPI(
                tags: .init(name: "Admin - TrainingRoom"),
                summary: "Получить список залов для администратора",
                description:
                    "Возвращает все залы, доступных текущему администратору.",
                response: .type([TrainingRoomDTO].self),
                auth: .bearer()
            )

        routes.grouped(uuidMiddleware)
            .get(":id", use: getTrainingRoomById)
            .openAPI(
                tags: .init(name: "Admin - TrainingRoom"),
                summary: "Получить зал по ID для администратора",
                description:
                    "Возвращает зал по его UUID. Требует прав администратора.",
                response: .type(TrainingRoomDTO.self),
                auth: .bearer()
            )

        routes.grouped(capacityMiddleware)
            .get("capacity", ":capacity", use: getTrainingRoomsByCapacity)
            .openAPI(
                tags: .init(name: "Admin - TrainingRoom"),
                summary: "Получить залы по вместительности для администратора",
                description:
                    "Возвращает залы по вместительности. Требует прав администратора.",
                response: .type([TrainingRoomDTO].self),
                auth: .bearer()
            )

        routes.grouped(nameMiddleware)
            .get("name", ":name", use: getTrainingRoomByName)
            .openAPI(
                tags: .init(name: "Admin - TrainingRoom"),
                summary: "Получить зал по названию для администратора",
                description:
                    "Возвращает зал по его названию. Требует прав администратора.",
                response: .type(TrainingRoomDTO.self),
                auth: .bearer()
            )
    }

    fileprivate func registerPostRoutes(_ routes: RoutesBuilder) {
        routes.grouped(createMiddleware)
            .post(use: createTrainingRoom)
            .openAPI(
                tags: .init(name: "Admin - TrainingRoom"),
                summary: "Создать зал для администратора",
                description: "Создать новый зал. Требует прав администратора.",
                body: .type(TrainingRoomCreateDTO.self),
                response: .type(TrainingRoomDTO.self),
                auth: .bearer()
            )
    }

    fileprivate func registerPutRoutes(_ routes: RoutesBuilder) {
        routes.grouped(uuidMiddleware)
            .grouped(roomMiddleware)
            .put(":id", use: updateTrainingRoomById)
            .openAPI(
                tags: .init(name: "Admin - TrainingRoom"),
                summary: "Обновить зал для администратора",
                description:
                    "Обновить данные существующего зал. Требует прав администратора.",
                body: .type(TrainingRoomUpdateDTO.self),
                response: .type(TrainingRoomDTO.self),
                auth: .bearer()
            )
    }

    fileprivate func registerDeleteRoutes(_ routes: RoutesBuilder) {
        routes.grouped(uuidMiddleware)
            .delete(":id", use: deleteTrainingRoomById)
            .openAPI(
                tags: .init(name: "Admin - TrainingRoom"),
                summary: "Удалить зал для администратора",
                description:
                    "Удалить данные зала. Требует прав администратора.",
                response: .type(HTTPStatus.self),
                auth: .bearer()
            )
    }
}

// MARK: - Routes Realization

extension TrainingRoomAdminController {
    @Sendable
    func getAllTrainingRooms(req: Request) async throws -> Response {
        try await service.findAll().map {
            TrainingRoomDTO(from: $0)
        }.encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func createTrainingRoom(req: Request) async throws -> Response {
        guard
            let room = try await service.create(
                try req.content.decode(TrainingRoomCreateDTO.self)
            )
        else { throw TrainingRoomError.invalidCreation }
        return try await TrainingRoomDTO(from: room)
            .encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func updateTrainingRoomById(req: Request) async throws -> Response {
        guard
            let room = try await service.update(
                id: try req.parameters.require("id", as: UUID.self),
                with: try req.content.decode(TrainingRoomUpdateDTO.self)
            )
        else { throw TrainingRoomError.invalidUpdate }
        return try await TrainingRoomDTO(from: room)
            .encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func deleteTrainingRoomById(req: Request) async throws -> HTTPStatus {
        try await service.delete(
            id: try req.parameters.require("id", as: UUID.self)
        )
        return .noContent
    }

    @Sendable
    func getTrainingRoomById(req: Request) async throws -> Response {
        guard
            let trainingRoom = try await service.find(
                id: try req.parameters.require("id", as: UUID.self)
            )
        else { throw TrainingRoomError.trainingRoomNotFound }
        return try await TrainingRoomDTO(from: trainingRoom)
            .encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func getTrainingRoomByName(req: Request) async throws -> Response {
        guard
            let trainingRoom = try await service.find(
                name: try req.parameters.require("name", as: String.self)
            )
        else { throw TrainingRoomError.trainingRoomNotFound }
        return try await TrainingRoomDTO(from: trainingRoom)
            .encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func getTrainingRoomsByCapacity(req: Request) async throws -> Response {
        return try await service.find(
            capacity: try req.parameters.require("capacity", as: Int.self)
        ).map {
            TrainingRoomDTO(from: $0)
        }.encodeResponse(status: .ok, for: req)
    }
}

extension TrainingRoomAdminController: @unchecked Sendable {}
