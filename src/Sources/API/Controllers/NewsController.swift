//
//  NewsController.swift
//  Backend
//
//  Created by Tskhovrebova Yana on 23.12.2025.
//

import Vapor
import Domain

public final class NewsController: RouteCollection {
    private let service: NewsServiceProtocol

    public init(service: NewsServiceProtocol) {
        self.service = service
    }

    public func boot(routes: RoutesBuilder) throws {
        let newsRoutes = routes.grouped("news")
        registerGetNewsRoute(newsRoutes)
    }
}

// MARK: - Route Registration

extension NewsController {
    private func registerGetNewsRoute(_ routes: RoutesBuilder) {
        routes.get(use: getNews)
            .openAPI(
                tags: .init(name: "News"),
                summary: "Получить новости по теме",
                description: "Возвращает список статей по выбранной теме ('health' или 'sports'). Параметры: topic, max, from, to",
                response: .type([Article].self)
            )
    }
}

// MARK: - Route Realization

extension NewsController {
    @Sendable
    func getNews(req: Request) async throws -> [Article] {
        let topic = req.query[String.self, at: "topic"]
        let max = req.query[Int.self, at: "max"]
        let from = req.query[String.self, at: "from"].flatMap { ISO8601DateFormatter().date(from: $0) }
        let to = req.query[String.self, at: "to"].flatMap { ISO8601DateFormatter().date(from: $0) }

        return try await service.getNews(
            topic: topic,
            max: max,
            from: from,
            to: to,
            client: req.client
        )
    }
}

extension NewsController: @unchecked Sendable {}
