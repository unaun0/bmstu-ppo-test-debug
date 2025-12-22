//
//  RegisterValidationMiddleware.swift
//  Backend
//
//  Created by Цховребова Яна on 04.05.2025.
//

import Domain
import Vapor

public struct RegisterValidationMiddleware: AsyncMiddleware {
    public init() {}

    public func respond(
        to request: Request,
        chainingTo next: AsyncResponder
    ) async throws -> Response {
        let json = try request.content.decode([String: String].self)
        try validateRegistrationFields(json)
        return try await next.respond(to: request)
    }
}

// MARK: - Validation Methods

private extension RegisterValidationMiddleware {
    func validateRegistrationFields(_ json: [String: String]) throws {
        try validateEmail(json)
        try validatePassword(json)
        try validatePhoneNumber(json)
        try validateFirstName(json)
        try validateLastName(json)
        try validateGender(json)
        try validateBirthDate(json)
    }

    func validateEmail(_ json: [String: String]) throws {
        guard let email = json["email"],
              UserValidator.validate(email: email)
        else {
            throw UserError.invalidEmail
        }
    }

    func validatePassword(_ json: [String: String]) throws {
        guard let password = json["password"],
              UserValidator.validate(password: password)
        else {
            throw UserError.passwordTooWeak
        }
    }

    func validatePhoneNumber(_ json: [String: String]) throws {
        guard let phoneNumber = json["phoneNumber"],
              UserValidator.validate(phoneNumber: phoneNumber)
        else {
            throw UserError.invalidPhoneNumber
        }
    }

    func validateFirstName(_ json: [String: String]) throws {
        guard let firstName = json["firstName"],
              UserValidator.validate(name: firstName)
        else {
            throw UserError.invalidFirstName
        }
    }

    func validateLastName(_ json: [String: String]) throws {
        guard let lastName = json["lastName"],
              UserValidator.validate(name: lastName)
        else {
            throw UserError.invalidLastName
        }
    }

    func validateGender(_ json: [String: String]) throws {
        guard let gender = json["gender"],
              UserValidator.validate(gender: gender)
        else {
            throw UserError.invalidGender
        }
    }

    func validateBirthDate(_ json: [String: String]) throws {
        guard let birthDateString = json["birthDate"],
              UserValidator.validate(date: birthDateString)
        else {
            throw UserError.invalidBirthDate
        }
    }
}
