//
//  Models.swift
//  Backend
//
//  Created by Tskhovrebova Yana on 23.12.2025.
//

import Vapor
import Domain

struct GNewsResponse: Content {
    let information: [String: [String: String]]?
    let totalArticles: Int
    let articles: [Article]
}
