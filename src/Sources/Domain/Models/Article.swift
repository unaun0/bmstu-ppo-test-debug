//
//  Article.swift
//  Backend
//
//  Created by Tskhovrebova Yana on 23.12.2025.
//

import Vapor

public struct NewsSource: Content {
    public let id: String?
    public let name: String
    public let url: String?
}

public struct Article: Content {
    public let id: String
    public let title: String
    public let description: String
    public let content: String
    public let url: String
    public let image: String?
    public let publishedAt: String
    public let lang: String
    public let source: NewsSource
}
