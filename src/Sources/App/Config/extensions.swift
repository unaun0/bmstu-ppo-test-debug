@preconcurrency import Domain
@preconcurrency import API
import Fluent
import Vapor

extension Application {
    private struct UserRepositoryKey: StorageKey {
        typealias Value = IUserRepository
    }
    var userRepository: IUserRepository? {
        get { self.storage[UserRepositoryKey.self] }
        set { self.storage[UserRepositoryKey.self] = newValue }
    }
}

extension Application {
    private struct AttendanceRepositoryKey: StorageKey {
        typealias Value = IAttendanceRepository
    }
    var attendanceRepository: IAttendanceRepository? {
        get { self.storage[AttendanceRepositoryKey.self] }
        set { self.storage[AttendanceRepositoryKey.self] = newValue }
    }
}

extension Application {
    private struct MembershipRepositoryKey: StorageKey {
        typealias Value = IMembershipRepository
    }
    var membershipRepository: IMembershipRepository? {
        get { self.storage[MembershipRepositoryKey.self] }
        set { self.storage[MembershipRepositoryKey.self] = newValue }
    }
}

extension Application {
    private struct TrainerRepositoryKey: StorageKey {
        typealias Value = ITrainerRepository
    }
    var trainerRepository: ITrainerRepository? {
        get { self.storage[TrainerRepositoryKey.self] }
        set { self.storage[TrainerRepositoryKey.self] = newValue }
    }
}

extension Application {
    private struct MembershipCreateValidationMiddlewareKey: StorageKey {
        typealias Value = MembershipCreateValidationMiddleware
    }
    var membershipCreateValidationMiddleware: MembershipCreateValidationMiddleware? {
        get {
            self.storage[MembershipCreateValidationMiddlewareKey.self]
        }
        set {
            self.storage[MembershipCreateValidationMiddlewareKey.self] =
                newValue
        }
    }
}

extension Application {
    private struct MembershipValidationMiddlewareKey: StorageKey {
        typealias Value = MembershipValidationMiddleware
    }
    var membershipValidationMiddleware: MembershipValidationMiddleware? {
        get {
            self.storage[MembershipValidationMiddlewareKey.self]
        }
        set {
            self.storage[MembershipValidationMiddlewareKey.self] = newValue
        }
    }
}

extension Application {
    private struct TrainingRoomRepositoryKey: StorageKey {
        typealias Value = ITrainingRoomRepository
    }
    var trainingRoomRepository: ITrainingRoomRepository? {
        get { self.storage[TrainingRoomRepositoryKey.self] }
        set { self.storage[TrainingRoomRepositoryKey.self] = newValue }
    }
}

extension Application {
    private struct TrainingRepositoryKey: StorageKey {
        typealias Value = ITrainingRepository
    }
    var trainingRepository: ITrainingRepository? {
        get { self.storage[TrainingRepositoryKey.self] }
        set { self.storage[TrainingRepositoryKey.self] = newValue }
    }
}

extension Application {
    private struct MembershipTypeRepositoryKey: StorageKey {
        typealias Value = IMembershipTypeRepository
    }
    var membershipTypeRepository: IMembershipTypeRepository? {
        get { self.storage[MembershipTypeRepositoryKey.self] }
        set { self.storage[MembershipTypeRepositoryKey.self] = newValue }
    }
}

extension Application {
    private struct UserServiceKey: StorageKey {
        typealias Value = IUserService
    }
    var userService: IUserService? {
        get { self.storage[UserServiceKey.self] }
        set { self.storage[UserServiceKey.self] = newValue }
    }
}

extension Application {
    private struct AttendanceServiceKey: StorageKey {
        typealias Value = IAttendanceService
    }
    var attendanceService: IAttendanceService? {
        get { self.storage[AttendanceServiceKey.self] }
        set { self.storage[AttendanceServiceKey.self] = newValue }
    }
}

extension Application {
    private struct UserAttendanceServiceKey: StorageKey {
        typealias Value = IAttendanceUserService
    }
    var userAttendanceService: IAttendanceUserService? {
        get { self.storage[UserAttendanceServiceKey.self] }
        set { self.storage[UserAttendanceServiceKey.self] = newValue }
    }
}

extension Application {
    private struct MembershipTypeServiceKey: StorageKey {
        typealias Value = IMembershipTypeService
    }
    var membershipTypeService: IMembershipTypeService? {
        get { self.storage[MembershipTypeServiceKey.self] }
        set { self.storage[MembershipTypeServiceKey.self] = newValue }
    }
}

extension Application {
    private struct MembershipServiceKey: StorageKey {
        typealias Value = IMembershipService
    }
    var membershipService: IMembershipService? {
        get { self.storage[MembershipServiceKey.self] }
        set { self.storage[MembershipServiceKey.self] = newValue }
    }
}

extension Application {
    private struct TrainingUserServiceKey: StorageKey {
        typealias Value = ITrainingUserService
    }
    var trainingUserService: ITrainingUserService? {
        get { self.storage[TrainingUserServiceKey.self] }
        set { self.storage[TrainingUserServiceKey.self] = newValue }
    }
}

extension Application {
    private struct TrainingTrainerServiceKey: StorageKey {
        typealias Value = ITrainingTrainerService
    }
    var trainingTrainerService: ITrainingTrainerService? {
        get { self.storage[TrainingTrainerServiceKey.self] }
        set { self.storage[TrainingTrainerServiceKey.self] = newValue }
    }
}

extension Application {
    private struct TrainingRoomServiceKey: StorageKey {
        typealias Value = ITrainingRoomService
    }
    var trainingRoomService: ITrainingRoomService? {
        get { self.storage[TrainingRoomServiceKey.self] }
        set { self.storage[TrainingRoomServiceKey.self] = newValue }
    }
}

extension Application {
    private struct TrainingServiceKey: StorageKey {
        typealias Value = ITrainingService
    }
    var trainingService: ITrainingService? {
        get { self.storage[TrainingServiceKey.self] }
        set { self.storage[TrainingServiceKey.self] = newValue }
    }
}

extension Application {
    private struct UserSelfServiceKey: StorageKey {
        typealias Value = IUserSelfService
    }
    var userSelfService: IUserSelfService? {
        get { self.storage[UserSelfServiceKey.self] }
        set { self.storage[UserSelfServiceKey.self] = newValue }
    }
}

extension Application {
    private struct TrainerSelfServiceKey: StorageKey {
        typealias Value = ITrainerSelfService
    }
    var trainerSelfService: ITrainerSelfService? {
        get { self.storage[TrainerSelfServiceKey.self] }
        set { self.storage[TrainerSelfServiceKey.self] = newValue }
    }
}

extension Application {
    private struct AuthServiceKey: StorageKey {
        typealias Value = IAuthService
    }
    var authService: IAuthService? {
        get { self.storage[AuthServiceKey.self] }
        set { self.storage[AuthServiceKey.self] = newValue }
    }
}

extension Application {
    private struct HasherServiceKey: StorageKey {
        typealias Value = IHasherService
    }
    var hasherService: IHasherService? {
        get { self.storage[HasherServiceKey.self] }
        set { self.storage[HasherServiceKey.self] = newValue }
    }
}

extension Application {
    private struct JWTServiceKey: StorageKey {
        typealias Value = IJWTService
    }
    var jwtService: IJWTService? {
        get { self.storage[JWTServiceKey.self] }
        set { self.storage[JWTServiceKey.self] = newValue }
    }
}

extension Application {
    private struct JWTMiddlewareKey: StorageKey {
        typealias Value = JWTMiddleware
    }
    var jwtMiddleware: JWTMiddleware? {
        get { self.storage[JWTMiddlewareKey.self] }
        set { self.storage[JWTMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct LoginValidationMiddlewareKey: StorageKey {
        typealias Value = LoginValidationMiddleware
    }
    var loginValidationMiddleware: LoginValidationMiddleware? {
        get { self.storage[LoginValidationMiddlewareKey.self] }
        set { self.storage[LoginValidationMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct RegisterValidationMiddlewareKey: StorageKey {
        typealias Value = RegisterValidationMiddleware
    }
    var registerValidationMiddleware: RegisterValidationMiddleware? {
        get { self.storage[RegisterValidationMiddlewareKey.self] }
        set { self.storage[RegisterValidationMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct UserValidationMiddlewareKey: StorageKey {
        typealias Value = UserValidationMiddleware
    }
    var userValidationMiddleware: UserValidationMiddleware? {
        get { self.storage[UserValidationMiddlewareKey.self] }
        set { self.storage[UserValidationMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct UUIDValidationMiddlewareKey: StorageKey {
        typealias Value = UUIDValidationMiddleware
    }
    var uuidValidationMiddleware: UUIDValidationMiddleware? {
        get { self.storage[UUIDValidationMiddlewareKey.self] }
        set { self.storage[UUIDValidationMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct UserEmailValidationMiddlewareKey: StorageKey {
        typealias Value = UserEmailValidationMiddleware
    }
    var userEmailValidationMiddleware: UserEmailValidationMiddleware? {
        get { self.storage[UserEmailValidationMiddlewareKey.self] }
        set { self.storage[UserEmailValidationMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct UserPhoneNumberValidationMiddlewareKey: StorageKey {
        typealias Value = UserPhoneNumberValidationMiddleware
    }
    var userPhoneNumberValidationMiddleware: UserPhoneNumberValidationMiddleware? {
        get { self.storage[UserPhoneNumberValidationMiddlewareKey.self] }
        set { self.storage[UserPhoneNumberValidationMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct AdminRoleMiddlewareKey: StorageKey {
        typealias Value = AdminRoleMiddleware
    }
    var adminRoleMiddleware: AdminRoleMiddleware? {
        get { self.storage[AdminRoleMiddlewareKey.self] }
        set { self.storage[AdminRoleMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct TrainerRoleMiddlewareKey: StorageKey {
        typealias Value = TrainerRoleMiddleware
    }
    var trainerRoleMiddleware: TrainerRoleMiddleware? {
        get { self.storage[TrainerRoleMiddlewareKey.self] }
        set { self.storage[TrainerRoleMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct AdminOrTrainerRoleMiddlewareKey: StorageKey {
        typealias Value = AdminOrTrainerRoleMiddleware
    }
    var adminOrTrainerRoleMiddleware: AdminOrTrainerRoleMiddleware? {
        get { self.storage[AdminOrTrainerRoleMiddlewareKey.self] }
        set { self.storage[AdminOrTrainerRoleMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct IUserTrainerServiceKey: StorageKey {
        typealias Value = IUserTrainerService
    }
    var userTrainerService: IUserTrainerService? {
        get { self.storage[IUserTrainerServiceKey.self] }
        set { self.storage[IUserTrainerServiceKey.self] = newValue }
    }
}

extension Application {
    private struct UserRoleNameValidationMiddlewareKey: StorageKey {
        typealias Value = UserRoleNameValidationMiddleware
    }
    var userRoleNameValidationMiddleware: UserRoleNameValidationMiddleware? {
        get { self.storage[UserRoleNameValidationMiddlewareKey.self] }
        set {
            self.storage[UserRoleNameValidationMiddlewareKey.self] = newValue
        }
    }
}

extension Application {
    private struct UserCreateValidationMiddlewareKey: StorageKey {
        typealias Value = UserCreateValidationMiddleware
    }
    var userCreateValidationMiddleware: UserCreateValidationMiddleware? {
        get { self.storage[UserCreateValidationMiddlewareKey.self] }
        set { self.storage[UserCreateValidationMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct TrainerValidationMiddlewareKey: StorageKey {
        typealias Value = TrainerValidationMiddleware
    }
    var trainerValidationMiddleware: TrainerValidationMiddleware? {
        get { self.storage[TrainerValidationMiddlewareKey.self] }
        set { self.storage[TrainerValidationMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct TrainerCreateValidationMiddlewareKey: StorageKey {
        typealias Value = TrainerCreateValidationMiddleware
    }
    var trainerCreateValidationMiddleware: TrainerCreateValidationMiddleware? {
        get { self.storage[TrainerCreateValidationMiddlewareKey.self] }
        set {
            self.storage[TrainerCreateValidationMiddlewareKey.self] = newValue
        }
    }
}

extension Application {
    private struct TrainerServiceKey: StorageKey {
        typealias Value = ITrainerService
    }
    var trainerService: ITrainerService? {
        get { self.storage[TrainerServiceKey.self] }
        set { self.storage[TrainerServiceKey.self] = newValue }
    }
}

extension Application {
    private struct TrainerUserServiceKey: StorageKey {
        typealias Value = ITrainerUserService
    }
    var trainerUserService: ITrainerUserService? {
        get { self.storage[TrainerUserServiceKey.self] }
        set { self.storage[TrainerUserServiceKey.self] = newValue }
    }
}

extension Application {
    private struct TrainingRoomCreateValidationMiddlewareKey: StorageKey {
        typealias Value = TrainingRoomCreateValidationMiddleware
    }

    var trainingRoomCreateValidationMiddleware: TrainingRoomCreateValidationMiddleware? {
        get { self.storage[TrainingRoomCreateValidationMiddlewareKey.self] }
        set {
            self.storage[TrainingRoomCreateValidationMiddlewareKey.self] =
                newValue
        }
    }
}

extension Application {
    private struct TrainingRoomFindByCapacityValidationMiddlewareKey: StorageKey {
        typealias Value = TrainingRoomFindByCapacityValidationMiddleware
    }

    var trainingRoomFindByCapacityValidationMiddleware: TrainingRoomFindByCapacityValidationMiddleware? {
        get {
            self.storage[TrainingRoomFindByCapacityValidationMiddlewareKey.self]
        }
        set {
            self.storage[
                TrainingRoomFindByCapacityValidationMiddlewareKey.self
            ] = newValue
        }
    }
}

extension Application {
    private struct TrainingRoomFindByNameValidationMiddlewareKey: StorageKey {
        typealias Value = TrainingRoomFindByNameValidationMiddleware
    }

    var trainingRoomFindByNameValidationMiddleware: TrainingRoomFindByNameValidationMiddleware? {
        get { self.storage[TrainingRoomFindByNameValidationMiddlewareKey.self] }
        set {
            self.storage[TrainingRoomFindByNameValidationMiddlewareKey.self] =
                newValue
        }
    }
}

extension Application {
    private struct TrainingRoomValidationMiddlewareKey: StorageKey {
        typealias Value = TrainingRoomValidationMiddleware
    }

    var trainingRoomValidationMiddleware: TrainingRoomValidationMiddleware? {
        get { self.storage[TrainingRoomValidationMiddlewareKey.self] }
        set {
            self.storage[TrainingRoomValidationMiddlewareKey.self] = newValue
        }
    }
}

extension Application {
    private struct TrainingCreateValidationMiddlewareKey: StorageKey {
        typealias Value = TrainingCreateValidationMiddleware
    }
    var trainingCreateValidationMiddleware: TrainingCreateValidationMiddleware? {
        get { self.storage[TrainingCreateValidationMiddlewareKey.self] }
        set {
            self.storage[TrainingCreateValidationMiddlewareKey.self] = newValue
        }
    }
}

extension Application {
    private struct TrainingValidationMiddlewareKey: StorageKey {
        typealias Value = TrainingValidationMiddleware
    }
    var trainingValidationMiddleware: TrainingValidationMiddleware? {
        get { self.storage[TrainingValidationMiddlewareKey.self] }
        set { self.storage[TrainingValidationMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct MembershipTypeCreateValidationMiddlewareKey: StorageKey {
        typealias Value = MembershipTypeCreateValidationMiddleware
    }

    var membershipTypeCreateValidationMiddleware: MembershipTypeCreateValidationMiddleware? {
        get { self.storage[MembershipTypeCreateValidationMiddlewareKey.self] }
        set {
            self.storage[MembershipTypeCreateValidationMiddlewareKey.self] =
                newValue
        }
    }
}

extension Application {
    private struct MembershipTypeFindByNameValidationMiddlewareKey: StorageKey {
        typealias Value = MembershipTypeFindByNameValidationMiddleware
    }

    var membershipTypeFindByNameValidationMiddleware: MembershipTypeFindByNameValidationMiddleware? {
        get {
            self.storage[MembershipTypeFindByNameValidationMiddlewareKey.self]
        }
        set {
            self.storage[MembershipTypeFindByNameValidationMiddlewareKey.self] = newValue
        }
    }
}

extension Application {
    private struct MembershipTypeValidationMiddlewareKey: StorageKey {
        typealias Value = MembershipTypeValidationMiddleware
    }

    var membershipTypeValidationMiddleware: MembershipTypeValidationMiddleware? {
        get { self.storage[MembershipTypeValidationMiddlewareKey.self] }
        set { self.storage[MembershipTypeValidationMiddlewareKey.self] = newValue }
    }
}

extension Application {
    private struct AttendanceCreateValidationMiddlewareKey: StorageKey {
        typealias Value = AttendanceCreateValidationMiddleware
    }

    var attendanceCreateValidationMiddleware: AttendanceCreateValidationMiddleware? {
        get {
            self.storage[AttendanceCreateValidationMiddlewareKey.self]
        }
        set {
            self.storage[AttendanceCreateValidationMiddlewareKey.self] = newValue
        }
    }
}

extension Application {
    private struct AttendanceValidationMiddlewareKey: StorageKey {
        typealias Value = AttendanceValidationMiddleware
    }

    var attendanceValidationMiddleware: AttendanceValidationMiddleware? {
        get {
            self.storage[AttendanceValidationMiddlewareKey.self]
        }
        set {
            self.storage[AttendanceValidationMiddlewareKey.self] = newValue
        }
    }
}

