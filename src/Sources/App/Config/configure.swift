import API
import DataAccess
@preconcurrency import Domain
import Fluent
import FluentMongoDriver
import FluentPostgresDriver
import NIOSSL
import Vapor

public func configure(_ app: Application) async throws {
    app.middleware.use(
        FileMiddleware(
            publicDirectory:
                "/Users/tshyana/Desktop/bmstu/test-debug/src/Public/"
        )
    )
    let dbConfig = app.appConfig.databaseConfig(for: app.environment)
    app.middleware.use(
        FileMiddleware(
            publicDirectory: app.directory.publicDirectory
        )
    )
    app.databases.use(
        DatabaseConfigurationFactory.postgres(
            configuration: .init(
                hostname: dbConfig.hostname,
                port: dbConfig.port,
                username: dbConfig.username,
                password: dbConfig.password,
                database: dbConfig.databaseName,
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        ),
        as: .psql
    )
    app.jwt.signers.use(
        .hs256(key: app.appConfig.jwt.secretKey)
    )
    configureRepositories(app)
    configureServices(app, config: app.appConfig)
    configureJWTSecretKey(app, config: app.appConfig)
    configureMiddlewares(app)

    try routes(app)
}

extension Application {
    var mongo: Database {
        self.databases.database(
            .mongo,
            logger: self.logger,
            on: self.eventLoopGroup.next()
        )!
    }

    var postgres: Database {
        self.databases.database(
            .psql,
            logger: self.logger,
            on: self.eventLoopGroup.next()
        )!
    }
}

private func configureJWTSecretKey(_ app: Application, config: AppConfig) {
    app.jwt.signers.use(
        .hs256(key: config.jwt.secretKey)
    )
}

private func configureRepositories(_ app: Application) {
    app.userRepository = UserRepository(db: app.postgres)
    app.trainerRepository = TrainerRepository(db: app.postgres)
    app.membershipTypeRepository = MembershipTypeRepository(db: app.postgres)
    app.trainingRoomRepository = TrainingRoomRepository(db: app.postgres)
    app.trainingRepository = TrainingRepository(db: app.postgres)
    app.membershipRepository = MembershipRepository(db: app.postgres)
    app.attendanceRepository = AttendanceRepository(db: app.postgres)
}

private func configureServices(_ app: Application, config: AppConfig) {
    app.hasherService = BcryptHasherService()
    app.jwtService = JWTService(
        expirationTime: TimeInterval(
            config.jwt.expirationTime
        )
    )
    app.userService = UserService(
        userRepository: app.userRepository!,
        passwordHasher: app.hasherService!
    )
    app.authService = AuthService(
        userService: app.userService!,
        passwordHasher: app.hasherService!
    )
    app.userSelfService = UserSelfService(
        userService: app.userService!
    )
    app.userTrainerService = UserTrainerService(
        userService: app.userService!
    )
    app.trainerService = TrainerService(
        repository: app.trainerRepository!
    )
    app.trainerUserService = TrainerUserService(
        trainerService: app.trainerService!,
        userService: app.userService!
    )
    app.trainerSelfService = TrainerSelfService(
        trainerService: app.trainerService!
    )
    app.trainingRoomService = TrainingRoomService(
        repository: app.trainingRoomRepository!
    )
    app.trainingService = TrainingService(
        repository: app.trainingRepository!
    )
    app.trainingUserService = TrainingUserService(
        trainingService: app.trainingService!,
        roomService: app.trainingRoomService!,
        trainerService: app.trainerService!,
        userService: app.userService!
    )
    app.trainingTrainerService = TrainingTrainerService(
        trainingService: app.trainingService!,
        roomService: app.trainingRoomService!,
        trainerService: app.trainerService!,
        userService: app.userService!
    )
    app.membershipTypeService = MembershipTypeService(
        repository: app.membershipTypeRepository!
    )
    app.membershipService = MembershipService(
        membershipRepository: app.membershipRepository!,
        membershipTypeService: app.membershipTypeService!
    )
    app.attendanceService = AttendanceService(
        repository: app.attendanceRepository!
    )
    app.userAttendanceService = AttendanceUserService(
        attendanceService: app.attendanceService!,
        membershipService: app.membershipService!,
        trainingService: app.trainingService!
    )
}

private func configureMiddlewares(_ app: Application) {
    app.jwtMiddleware = JWTMiddleware(userService: app.userService!)
    app.loginValidationMiddleware = LoginValidationMiddleware()
    app.registerValidationMiddleware = RegisterValidationMiddleware()
    app.userValidationMiddleware = UserValidationMiddleware()
    app.uuidValidationMiddleware = UUIDValidationMiddleware()
    app.userEmailValidationMiddleware = UserEmailValidationMiddleware()
    app.userPhoneNumberValidationMiddleware =
        UserPhoneNumberValidationMiddleware()
    app.adminRoleMiddleware = AdminRoleMiddleware()
    app.trainerRoleMiddleware = TrainerRoleMiddleware()
    app.adminOrTrainerRoleMiddleware = AdminOrTrainerRoleMiddleware(
        adminMiddleware: app.adminRoleMiddleware!,
        trainerMiddleware: app.trainerRoleMiddleware!
    )
    app.userRoleNameValidationMiddleware = UserRoleNameValidationMiddleware()
    app.userCreateValidationMiddleware = UserCreateValidationMiddleware()
    app.trainerValidationMiddleware = TrainerValidationMiddleware()
    app.trainerCreateValidationMiddleware = TrainerCreateValidationMiddleware()
    app.trainingRoomValidationMiddleware = TrainingRoomValidationMiddleware()
    app.trainingRoomCreateValidationMiddleware =
        TrainingRoomCreateValidationMiddleware()
    app.trainingRoomFindByNameValidationMiddleware =
        TrainingRoomFindByNameValidationMiddleware()
    app.trainingRoomFindByCapacityValidationMiddleware =
        TrainingRoomFindByCapacityValidationMiddleware()
    app.trainingCreateValidationMiddleware =
        TrainingCreateValidationMiddleware()
    app.trainingValidationMiddleware = TrainingValidationMiddleware()
    app.membershipTypeCreateValidationMiddleware =
        MembershipTypeCreateValidationMiddleware()
    app.membershipTypeFindByNameValidationMiddleware =
        MembershipTypeFindByNameValidationMiddleware()
    app.membershipTypeValidationMiddleware =
        MembershipTypeValidationMiddleware()
    app.membershipCreateValidationMiddleware = .init()
    app.membershipValidationMiddleware = .init()
    app.attendanceCreateValidationMiddleware =
        AttendanceCreateValidationMiddleware()
    app.attendanceValidationMiddleware = AttendanceValidationMiddleware()
}
