//
//  UserAdminController.swift
//  Backend
//
//  Created by Цховребова Яна on 20.03.2025.
//

import Domain
import Vapor
import VaporToOpenAPI

public final class UserAdminController: RouteCollection {
    private let service: IUserService
    private let jwtMiddleware: JWTMiddleware
    private let adminMiddleware: AdminRoleMiddleware
    private let uuidMiddleware: UUIDValidationMiddleware
    private let emailMiddleware: UserEmailValidationMiddleware
    private let phoneMiddleware: UserPhoneNumberValidationMiddleware
    private let roleMiddleware: UserRoleNameValidationMiddleware
    private let userCreateMiddleware: UserCreateValidationMiddleware

    public init(
        service: IUserService,
        jwtMiddleware: JWTMiddleware,
        adminMiddleware: AdminRoleMiddleware,
        uuidMiddleware: UUIDValidationMiddleware,
        emailMiddleware: UserEmailValidationMiddleware,
        phoneMiddleware: UserPhoneNumberValidationMiddleware,
        roleMiddleware: UserRoleNameValidationMiddleware,
        userCreateMiddleware: UserCreateValidationMiddleware
    ) {
        self.service = service
        self.jwtMiddleware = jwtMiddleware
        self.adminMiddleware = adminMiddleware
        self.uuidMiddleware = uuidMiddleware
        self.emailMiddleware = emailMiddleware
        self.phoneMiddleware = phoneMiddleware
        self.roleMiddleware = roleMiddleware
        self.userCreateMiddleware = userCreateMiddleware
    }

    public func boot(routes: RoutesBuilder) throws {
        let userRoutes = setupRoutes(routes)
        registerAllUsersRoute(userRoutes)
        registerGetByIdRoute(userRoutes)
        registerGetByEmailRoute(userRoutes)
        registerGetByPhoneRoute(userRoutes)
        registerGetByRoleRoute(userRoutes)
        registerPostRoutes(userRoutes)
        registerPutRoutes(userRoutes)
        registerDeleteRoutes(userRoutes)
    }
}

// MARK: - Route Registration

extension UserAdminController {
    fileprivate func setupRoutes(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes.grouped("admin")
            .grouped("users")
            .grouped(jwtMiddleware)
            .grouped(adminMiddleware)
    }

    fileprivate func registerAllUsersRoute(_ routes: RoutesBuilder) {
        routes.get("all", use: getAllUsers)
            .openAPI(
                tags: .init(name: "Admin - User"),
                summary: "Получить список пользователей для администратора",
                description: "Возвращает всех пользователей, доступных текущему администратору.",
                response: .type([UserAdminDTO].self),
                auth: .bearer()
            )
    }

    fileprivate func registerGetByIdRoute(_ routes: RoutesBuilder) {
        routes.grouped(uuidMiddleware)
            .get(":id", use: getUserById)
            .openAPI(
                tags: .init(name: "Admin - User"),
                summary: "Получить пользователя по ID для администратора",
                description: "Возвращает профиль пользователя по его UUID. Требует прав администратора.",
                response: .type(UserAdminDTO.self),
                auth: .bearer()
            )
    }

    fileprivate func registerGetByEmailRoute(_ routes: RoutesBuilder) {
        routes.grouped(emailMiddleware)
            .get("email", ":email", use: getUserByEmail)
            .openAPI(
                tags: .init(name: "Admin - User"),
                summary: "Получить пользователя по email для администратора",
                description: "Возвращает профиль пользователя по email. Требует прав администратора.",
                response: .type(UserAdminDTO.self),
                auth: .bearer()
            )
    }

    fileprivate func registerGetByPhoneRoute(_ routes: RoutesBuilder) {
        routes.grouped(phoneMiddleware)
            .get("phone-number", ":phone-number", use: getUserByPhone)
            .openAPI(
                tags: .init(name: "Admin - User"),
                summary: "Получить пользователя по номеру телефона для администратора",
                description: "Возвращает профиль пользователя по номеру телефона. Требует прав администратора.",
                response: .type(UserAdminDTO.self),
                auth: .bearer()
            )
    }

    fileprivate func registerGetByRoleRoute(_ routes: RoutesBuilder) {
        routes.grouped(roleMiddleware)
            .get("role", ":role", use: getUsersByRole)
            .openAPI(
                tags: .init(name: "Admin - User"),
                summary: "Получить пользователя по роли для администратора",
                description: "Возвращает список пользователей по роли. Требует прав администратора.",
                response: .type([UserAdminDTO].self),
                auth: .bearer()
            )
    }

    fileprivate func registerPostRoutes(_ routes: RoutesBuilder) {
        routes.grouped(userCreateMiddleware)
            .post(use: createUser)
            .openAPI(
                tags: .init(name: "Admin - User"),
                summary: "Создать нового пользователя для администратора",
                description: "Создает нового пользователя. Требует прав администратора.",
                body: .type(UserCreateDTO.self),
                response: .type(UserAdminDTO.self),
                auth: .bearer()
            )
    }

    fileprivate func registerPutRoutes(_ routes: RoutesBuilder) {
        routes.grouped(uuidMiddleware)
            .put(":id", use: updateUserById)
            .openAPI(
                tags: .init(name: "Admin - User"),
                summary: "Обновить данные пользователя для администратора",
                description: "Обновляет данные пользователя. Требует прав администратора.",
                body: .type(UserUpdateDTO.self),
                response: .type(UserAdminDTO.self),
                auth: .bearer()
            )
    }

    fileprivate func registerDeleteRoutes(_ routes: RoutesBuilder) {
        routes.grouped(uuidMiddleware)
            .delete(":id", use: deleteUserById)
            .openAPI(
                tags: .init(name: "Admin - User"),
                summary: "Удалить пользователя для администратора",
                description: "Удаляет пользователя. Требует прав администратора.",
                response: .type(HTTPStatus.self),
                auth: .bearer()
            )
    }
}

// MARK: - Routes Realization

extension UserAdminController {
    @Sendable
    func getAllUsers(req: Request) async throws -> Response {
        try await service.findAll().map {
            UserAdminDTO(from: $0)
        }.encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func getUserById(req: Request) async throws -> Response {
        guard let user = try await service.find(
            id: try req.parameters.require("id", as: UUID.self)
        ) else { throw UserError.userNotFound }
        return try await UserAdminDTO(from: user)
            .encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func getUserByEmail(req: Request) async throws -> Response {
        guard let user = try await service.find(
            email: try req.parameters.require("email", as: String.self)
        ) else { throw UserError.userNotFound }
        return try await UserAdminDTO(from: user)
            .encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func getUserByPhone(req: Request) async throws -> Response {
        guard let user = try await service.find(
            phoneNumber: try req.parameters.require("phone-number", as: String.self)
        ) else { throw UserError.userNotFound }
        return try await UserAdminDTO(from: user)
            .encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func getUsersByRole(req: Request) async throws -> Response {
        return try await service.find(
            role: try req.parameters.require("role", as: String.self)
        ).map {
            UserAdminDTO(from: $0)
        }.encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func updateUserById(req: Request) async throws -> Response {
        guard let user = try await service.update(
            id: try req.parameters.require("id", as: UUID.self),
            with: try req.content.decode(UserUpdateDTO.self)
        ) else { throw UserError.userNotFound }
        return try await UserAdminDTO(from: user)
            .encodeResponse(status: .ok, for: req)
    }

    @Sendable
    func deleteUserById(req: Request) async throws -> HTTPStatus {
        try await service.delete(
            id: try req.parameters.require("id", as: UUID.self)
        )
        return .noContent
    }

    @Sendable
    func createUser(req: Request) async throws -> Response {
        let user = try await service.create(
            try req.content.decode(UserCreateDTO.self)
        )
        guard let user else { throw UserError.creationFailed }
        return try await UserAdminDTO(from: user)
            .encodeResponse(status: .ok, for: req)
    }
}

extension UserAdminController: @unchecked Sendable {}
