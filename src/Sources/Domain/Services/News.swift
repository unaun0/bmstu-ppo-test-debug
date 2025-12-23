//
//  News.swift
//  Backend
//
//  Created by Tskhovrebova Yana on 23.12.2025.
//

import Vapor

public protocol NewsServiceProtocol {
    func getNews(
        topic: String?,
        max: Int?,
        from: Date?,
        to: Date?,
        client: Client
    ) async throws -> [Article]
}

public final class NewsService: NewsServiceProtocol {
    private let client: NewsClient
    private let defaultTopic = "health"
    private let allowedTopics = ["health", "sports"]
    private let defaultMax = 3

    public init(client: NewsClient) {
        self.client = client
    }

    public func getNews(
        topic: String? = nil,
        max: Int? = nil,
        from: Date? = nil,
        to: Date? = nil,
        client httpClient: Client
    ) async throws -> [Article] {
        let chosenTopic = topic ?? defaultTopic
        guard allowedTopics.contains(chosenTopic) else {
            throw Abort(
                .badRequest,
                reason: "Тема должна быть 'health' или 'sports'"
            )
        }
        let chosenMax = max ?? defaultMax
        if chosenMax <= 0 {
            throw Abort(
                .badRequest,
                reason: "Максимальное количество должно быть больше 0"
            )
        }
        if let from = from, let to = to, from > to {
            throw Abort(
                .badRequest,
                reason: "'from' дата не может быть позже 'to' даты"
            )
        }
        return try await client.fetchNews(
            topic: chosenTopic,
            max: chosenMax,
            from: from,
            to: to,
            client: httpClient
        )
    }
}
