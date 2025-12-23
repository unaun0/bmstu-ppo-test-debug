import API
import Domain
import Vapor
import VaporToOpenAPI

func routes(_ app: Application) throws {
    try registerSwaggerRoute(app)
    try registerAuthRoutes(app)
    try registerUserRoutes(app)
    try registerTrainerRoutes(app)
    try registerTrainingRoutes(app)
    try registerMembershipRoutes(app)
    try registerAttendanceRoutes(app)
}

// MARK: - Swagger
private func registerSwaggerRoute(_ app: Application) throws {
    app.get { req async in "It works!" }

    app.get("swagger.json") { req in
        req.application.routes.openAPI(
            info: InfoObject(
                title: "Fitness Club API",
                description: "API для управления фитнес-клубом.",
                version: "1.0.0"
            ),
            components: ComponentsObject(
                securitySchemes: [
                    "bearerAuth": .value(
                        SecuritySchemeObject(
                            type: .http,
                            scheme: "bearer",
                            bearerFormat: "JWT"
                        )
                    )
                ]
            )
        )
    }
}

// MARK: - Auth
private func registerAuthRoutes(_ app: Application) throws {
    let authController = AuthController(
        authService: app.authService!,
        jwtService: app.jwtService!,
        registerMiddleware: app.registerValidationMiddleware!,
        loginMiddleware: app.loginValidationMiddleware!
    )
    try app.register(collection: authController)
    
    let newsController = NewsController(
        service: app.newsService!
    )
    try app.register(collection: newsController)
}

// MARK: - User Routes
private func registerUserRoutes(_ app: Application) throws {
    let userSelfController = UserSelfController(
        service: app.userSelfService!,
        jwtMiddleware: app.jwtMiddleware!,
        validationMiddleware: app.userValidationMiddleware!
    )
    try app.register(collection: userSelfController)

    let userTrainerController = UserTrainerController(
        service: app.userTrainerService!,
        jwtMiddleware: app.jwtMiddleware!,
        trainerMiddleware: app.adminOrTrainerRoleMiddleware!,
        uuidMiddleware: app.uuidValidationMiddleware!,
        emailMiddleware: app.userEmailValidationMiddleware!,
        phoneMiddleware: app.userPhoneNumberValidationMiddleware!
    )
    try app.register(collection: userTrainerController)

    let userAdminController = UserAdminController(
        service: app.userService!,
        jwtMiddleware: app.jwtMiddleware!,
        adminMiddleware: app.adminRoleMiddleware!,
        uuidMiddleware: app.uuidValidationMiddleware!,
        emailMiddleware: app.userEmailValidationMiddleware!,
        phoneMiddleware: app.userPhoneNumberValidationMiddleware!,
        roleMiddleware: app.userRoleNameValidationMiddleware!,
        userCreateMiddleware: app.userCreateValidationMiddleware!
    )
    try app.register(collection: userAdminController)
}

// MARK: - Trainer Routes
private func registerTrainerRoutes(_ app: Application) throws {
    let trainerAdminController = TrainerAdminController(
        service: app.trainerService!,
        jwtMiddleware: app.jwtMiddleware!,
        adminMiddleware: app.adminRoleMiddleware!,
        trainerMiddleware: app.trainerValidationMiddleware!,
        trainerCreateMiddleware: app.trainerCreateValidationMiddleware!,
        uuidMiddleware: app.uuidValidationMiddleware!
    )
    try app.register(collection: trainerAdminController)

    let trainerUserController = TrainerUserController(
        service: app.trainerUserService!,
        jwtMiddleware: app.jwtMiddleware!,
        uuidMiddleware: app.uuidValidationMiddleware!
    )
    try app.register(collection: trainerUserController)

    let trainerSelfController = TrainerSelfController(
        service: app.trainerSelfService!,
        jwtMiddleware: app.jwtMiddleware!,
        trainerMiddleware: app.adminOrTrainerRoleMiddleware!
    )
    try app.register(collection: trainerSelfController)
}

// MARK: - Training Routes
private func registerTrainingRoutes(_ app: Application) throws {
    let trainingRoomAdminController = TrainingRoomAdminController(
        service: app.trainingRoomService!,
        adminRoleMiddleware: app.adminRoleMiddleware!,
        jwtMiddleware: app.jwtMiddleware!,
        roomMiddleware: app.trainingRoomValidationMiddleware!,
        createMiddleware: app.trainingRoomCreateValidationMiddleware!,
        nameMiddleware: app.trainingRoomFindByNameValidationMiddleware!,
        capacityMiddleware: app.trainingRoomFindByCapacityValidationMiddleware!,
        uuidMiddleware: app.uuidValidationMiddleware!
    )
    try app.register(collection: trainingRoomAdminController)

    let trainingAdminController = TrainingAdminController(
        trainingService: app.trainingService!,
        adminRoleMiddleware: app.adminRoleMiddleware!,
        jwtMiddleware: app.jwtMiddleware!,
        createValidationMiddleware: app.trainingCreateValidationMiddleware!,
        validationMiddleware: app.trainingValidationMiddleware!,
        uuidValidationMiddleware: app.uuidValidationMiddleware!
    )
    try app.register(collection: trainingAdminController)

    let trainingUserController = TrainingUserController(
        trainingService: app.trainingUserService!,
        jwtMiddleware: app.jwtMiddleware!
    )
    try app.register(collection: trainingUserController)

    let trainingTrainerController = TrainingTrainerController(
        trainingService: app.trainingTrainerService!,
        jwtMiddleware: app.jwtMiddleware!,
        trainerMiddleware: app.adminOrTrainerRoleMiddleware!,
        createMiddleware: app.trainingCreateValidationMiddleware!,
        updateMiddleware: app.trainingValidationMiddleware!,
        uuidMiddleware: app.uuidValidationMiddleware!
    )
    try app.register(collection: trainingTrainerController)
}

// MARK: - Membership Routes
private func registerMembershipRoutes(_ app: Application) throws {
    let membershipTypeAdminController = MembershipTypeAdminController(
        service: app.membershipTypeService!,
        adminRoleMiddleware: app.adminRoleMiddleware!,
        jwtMiddleware: app.jwtMiddleware!,
        membershipTypeValidationMiddleware: app
            .membershipTypeValidationMiddleware!,
        membershipTypeCreateValidationMiddleware: app
            .membershipTypeCreateValidationMiddleware!,
        membershipTypeFindByNameValidationMiddleware: app
            .membershipTypeFindByNameValidationMiddleware!,
        uuidValidationMiddleware: app.uuidValidationMiddleware!
    )
    try app.register(collection: membershipTypeAdminController)

    let membershipTypeUserController = MembershipTypeUserController(
        service: app.membershipTypeService!,
        jwtMiddleware: app.jwtMiddleware!
    )
    try app.register(collection: membershipTypeUserController)

    let membershipAdminController = MembershipAdminController(
        service: app.membershipService!,
        jwtMiddleware: app.jwtMiddleware!,
        adminMiddleware: app.adminRoleMiddleware!,
        uuidMiddleware: app.uuidValidationMiddleware!,
        createMiddleware: app.membershipCreateValidationMiddleware!,
        updateMiddleware: app.membershipValidationMiddleware!
    )
    try app.register(collection: membershipAdminController)

    let membershipUserController = MembershipUserController(
        service: app.membershipService!,
        jwtMiddleware: app.jwtMiddleware!
    )
    try app.register(collection: membershipUserController)
}

// MARK: - Attendance Routes
private func registerAttendanceRoutes(_ app: Application) throws {
    let attendanceAdminController = AttendanceAdminController(
        service: app.attendanceService!,
        jwtMiddleware: app.jwtMiddleware!,
        adminMiddleware: app.adminRoleMiddleware!,
        uuidMiddleware: app.uuidValidationMiddleware!,
        createMiddleware: app.attendanceCreateValidationMiddleware!,
        updateMiddleware: app.attendanceValidationMiddleware!
    )
    try app.register(collection: attendanceAdminController)

    let attendanceUserController = AttendanceUserController(
        attendanceService: app.userAttendanceService!,
        jwtMiddleware: app.jwtMiddleware!,
        uuidMiddleware: app.uuidValidationMiddleware!,
        dataMiddleware: app.attendanceValidationMiddleware!
    )
    try app.register(collection: attendanceUserController)
}
