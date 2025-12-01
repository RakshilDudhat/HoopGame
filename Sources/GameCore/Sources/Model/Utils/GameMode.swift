public enum GameMode: String, Codable, Equatable {
    case new
    case existing
    case dailyChallenge
    case endless
}

public extension GameMode {
    var restartMode: GameMode {
        switch self {
        case .existing:
            return .new
        default:
            return self
        }
    }

    var initialLives: Int {
        switch self {
        case .dailyChallenge:
            return 1
        case .endless:
            return -1
        default:
            return 3
        }
    }

    var displayName: String {
        switch self {
        case .new:
            return "Classic Run"
        case .existing:
            return "Continue"
        case .dailyChallenge:
            return "Daily Challenge"
        case .endless:
            return "Endless Run"
        }
    }
}
