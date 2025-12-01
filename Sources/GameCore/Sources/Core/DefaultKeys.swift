import Model
import Defaults

public extension DefaultKeys {
    var ball: DefaultKey<BallStyle> { DefaultKey(name: "ball", defaultValue: .basketball) }
    var unlockedBalls: DefaultKey<[BallStyle]> { DefaultKey(name: "unlockedBalls", defaultValue: [.basketball]) }
    var coins: DefaultKey<Int> { DefaultKey(name: "coins", defaultValue: 0) }
    var currentGameMode: DefaultKey<GameMode> { DefaultKey(name: "currentGameMode", defaultValue: .new) }
    var lastDailyChallengeDate: DefaultKey<String> { DefaultKey(name: "lastDailyChallengeDate", defaultValue: "") }
}
