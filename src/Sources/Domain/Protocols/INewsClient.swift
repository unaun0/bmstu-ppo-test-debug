//
//  NewsClient.swift
//  Backend
//
//  Created by Tskhovrebova Yana on 23.12.2025.
//

import Vapor
import Foundation

public protocol NewsClient {
    func fetchNews(
        topic: String,
        max: Int?,
        from: Date?,
        to: Date?,
        client: Client
    ) async throws -> [Article]
}
