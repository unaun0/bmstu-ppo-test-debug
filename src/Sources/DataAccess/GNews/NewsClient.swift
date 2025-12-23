//
//  NewsClient.swift
//  Backend
//
//  Created by Tskhovrebova Yana on 23.12.2025.
//

import Vapor
import Domain

public final class GNewsClientAsyncImpl: NewsClient {
    private let apiKey: String
    private let baseURL: String

    public init(
        apiKey: String,
        baseURL: String
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
    }

    public func fetchNews(
        topic: String,
        max: Int? = nil,
        from: Date? = nil,
        to: Date? = nil,
        client: Client
    ) async throws -> [Article] {
        var queryItems = [
            URLQueryItem(name: "topic", value: topic),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        if let max = max {
            queryItems.append(URLQueryItem(name: "max", value: "\(max)"))
        }
        let formatter = ISO8601DateFormatter()
        if let from = from {
            queryItems.append(URLQueryItem(name: "from", value: formatter.string(from: from)))
        }
        if let to = to {
            queryItems.append(URLQueryItem(name: "to", value: formatter.string(from: to)))
        }
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = queryItems

        guard let urlString = urlComponents.url?.absoluteString else {
            throw Abort(.internalServerError, reason: "Invalid URL")
        }
        let response = try await client.get(URI(string: urlString))
        let articles = try response.content.decode(GNewsResponse.self).articles
        
        return articles
    }
}

