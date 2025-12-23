//
//  NewsE2ETests.swift
//  Backend
//
//  Created by Tskhovrebova Yana on 23.12.2025.
//

import Fluent
import FluentPostgresDriver
import Vapor
import VaporTesting
import XCTVapor
import XCTest

@testable import DataAccess
@testable import Domain
@testable import TestSupport

final class NewsE2ETests: XCTestCase {
    var fixture: FullAppTestFixture!

    override func setUp() async throws {
        try await super.setUp()
        fixture = try await FullAppTestFixture()
    }

    override func tearDown() async throws {
        try await fixture.shutdown()
        fixture = nil
        try await super.tearDown()
    }

    func testNewsScenarios() async throws {
        let port = 8090
        let running = try fixture.app.testable(method: .running(port: port))

        // 1. Топ новости по health
        try await running.test(
            .GET,
            "/news?topic=health&max=2",
            afterResponse: { res async throws in
                XCTAssertEqual(res.status, .ok)

                let articles = try res.content.decode([Article].self)
                XCTAssertLessThanOrEqual(articles.count, 2)
            }
        )

        // 2. Топ новости по sports
        try await running.test(
            .GET,
            "/news?topic=sports&max=3",
            afterResponse: { res async throws in
                XCTAssertEqual(res.status, .ok)

                let articles = try res.content.decode([Article].self)
                XCTAssertLessThanOrEqual(articles.count, 3)
            }
        )

        // 3. Некорректный топик
        try await running.test(
            .GET,
            "/news?topic=politics&max=2",
            afterResponse: { res async throws in
                XCTAssertEqual(res.status, .badRequest)
            }
        )
    }
}
