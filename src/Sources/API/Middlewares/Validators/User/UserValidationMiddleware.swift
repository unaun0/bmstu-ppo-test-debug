//
//  UserUpdateValidationMiddleware.swift
//  Backend
//
//  Created by Цховребова Яна on 28.03.2025.
//

import Domain
import Vapor

public struct UserValidationMiddleware: AsyncMiddleware {
    public init() {}

    public func respond(
        to request: Request,
        chainingTo next: AsyncResponder
    ) async throws -> Response {
        let json = try request.content.decode([String: String].self)
        try validate(json: json)
        return try await next.respond(to: request)
    }

    // MARK: - Private Validation Methods

    private func validate(json: [String: String]) throws {
        try validateEmail(json)
        try validatePassword(json)
        try validatePhoneNumber(json)
        try validateFirstName(json)
        try validateLastName(json)
        try validateGender(json)
        try validateBirthDate(json)
        try validateRole(json)
    }

    private func validateEmail(_ json: [String: String]) throws {
        if let email = json["email"], !UserValidator.validate(email: email) {
            throw UserError.invalidEmail
        }
    }

    private func validatePassword(_ json: [String: String]) throws {
        if let password = json["password"], !UserValidator.validate(password: password) {
            throw UserError.passwordTooWeak
        }
    }

    private func validatePhoneNumber(_ json: [String: String]) throws {
        if let phoneNumber = json["phoneNumber"], !UserValidator.validate(phoneNumber: phoneNumber) {
            throw UserError.invalidPhoneNumber
        }
    }

    private func validateFirstName(_ json: [String: String]) throws {
        if let firstName = json["firstName"], !UserValidator.validate(name: firstName) {
            throw UserError.invalidFirstName
        }
    }

    private func validateLastName(_ json: [String: String]) throws {
        if let lastName = json["lastName"], !UserValidator.validate(name: lastName) {
            throw UserError.invalidLastName
        }
    }

    private func validateGender(_ json: [String: String]) throws {
        if let gender = json["gender"], !UserValidator.validate(gender: gender) {
            throw UserError.invalidGender
        }
    }

    private func validateBirthDate(_ json: [String: String]) throws {
        if let birthDateString = json["birthDate"], !UserValidator.validate(date: birthDateString) {
            throw UserError.invalidBirthDate
        }
    }

    private func validateRole(_ json: [String: String]) throws {
        if let role = json["role"], !UserValidator.validate(roleName: role) {
            throw UserError.invalidRole
        }
    }
}
