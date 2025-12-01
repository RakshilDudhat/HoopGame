import Model
import Defaults
import SpriteKit
import Foundation
import Persistency

public class GameManager {
    internal var persistency: PersistencyService
    internal var userDefaults: UserDefaultService

    internal var gameObject: GameObject?
    public var currentGameMode: GameMode = .new
    public var dailyChallengeManager: DailyChallengeManager

    public var hoops: Hoops = []
    public var ball: Ball = Ball()
    public var alignment: NodeAlignment = .random()
    public var points: Int = .zero
    public var winningSteak: Int = .zero
    public var lives: Int = .zero
    public var scores: [Score] = []

    public var baseLine: CGFloat = .zero

    public init(persistency: PersistencyService, userDefaults: UserDefaultService) {
        self.persistency = persistency
        self.userDefaults = userDefaults
        self.dailyChallengeManager = DailyChallengeManager(userDefaults: userDefaults)
        self.loadPersistency()
    }
}

// MARK: - GAME LOADING
extension GameManager {
    public var isExistsGame: Bool {
        return gameObject != nil
    }

    /// load the new game
    public func loadGame(on frame: CGRect, mode: GameMode) {
        // Store or retrieve game mode
        if mode == .existing {
            // Load the stored game mode from when the game was saved
            currentGameMode = userDefaults.fetch(for: \.currentGameMode)
        } else {
            // Store the game mode for future reference
            currentGameMode = mode
            userDefaults.save(mode, for: \.currentGameMode)
        }
        
        switch mode {
        case .new:
            loadNewGame(on: frame)
        case .existing:
            loadExistingGame(on: frame)
            // Don't record for existing games - it was already recorded when started
        case .dailyChallenge:
            // Record that Daily Challenge was played today (only for new Daily Challenge games)
            dailyChallengeManager.recordDailyChallengePlayed()
            loadDailyChallenge(on: frame)
        case .endless:
            loadEndlessGame(on: frame)
        }
    }

    private func loadNewGame(on frame: CGRect) {
        loadFreshGame(on: frame, mode: .new)
    }

    private func loadDailyChallenge(on frame: CGRect) {
        loadFreshGame(on: frame, mode: .dailyChallenge)
    }

    private func loadEndlessGame(on frame: CGRect) {
        loadFreshGame(on: frame, mode: .endless)
    }

    private func loadExistingGame(on frame: CGRect) {
        if let existingGameObject = gameObject {
            points = existingGameObject.points
            winningSteak = existingGameObject.winningSteak
            lives = existingGameObject.lives
            alignment = NodeAlignment(rawValue: existingGameObject.nodeAlignment) ?? .center
            baseLine = existingGameObject.ball?.yPoint ?? 0
            ball = existingGameObject.ball?.model ?? Ball()
            hoops = existingGameObject.hoops?.array
                .compactMap { $0 as? HoopObject }
                .map { $0.model } ?? []
            self.gameObject = existingGameObject
        }
    }

    private func loadFreshGame(on frame: CGRect, mode: GameMode) {
        points = 0
        winningSteak = 0
        lives = mode.initialLives
        seedBall(on: frame)
        hoops.removeAll()
        for index in 1...3 {
            seedHoop(on: frame, for: index)
        }
        deleteGameObject(mode: mode)
        self.gameObject = loadNewGameObject()
    }

    /// prepare for next ball
    public func prepareForNextRound(on frame: CGRect, with location: CGPoint) {
        ball.location = location
        ball.location.y = baseLine
        let hoop = hoops.removeFirst()
        let diff = hoop.location.y - baseLine
        for index in hoops.indices {
            hoops[index].location.y -= diff
        }
        seedHoop(on: frame)
        updateGameObject()
    }

    /// calculate points after shot
    /// Returns: coins earned (0 if none)
    @discardableResult
    public func calculatePoints(_ count: Int, isBankShot: Bool, gameMode: GameMode? = nil) -> Int {
        // Use stored game mode if provided mode is .existing or nil
        let effectiveGameMode: GameMode
        if let providedMode = gameMode, providedMode != .existing {
            effectiveGameMode = providedMode
        } else {
            effectiveGameMode = currentGameMode
        }
        
        var points = 3
        if count > 1 {
            points += 2 * (count - 1)
        }
        if isBankShot {
            points += 2
        }
        if winningSteak >= 2 {
            points *= winningSteak
        }
        winningSteak += 1
        self.points += points

        // Random coin earning - 25% chance to get coins per basket
        var coinsEarned = 0
        if effectiveGameMode != .endless {
            let shouldEarnCoins = Double.random(in: 0...1) < 0.8
            if shouldEarnCoins {
                // Different coin ranges based on game mode
                let coinRange: ClosedRange<Int>
                if effectiveGameMode == .dailyChallenge {
                    coinRange = 10...20
                } else {
                    coinRange = 1...10
                }
                coinsEarned = Int.random(in: coinRange)
                var currentCoins = userDefaults.fetch(for: \.coins)
                currentCoins += coinsEarned
                userDefaults.save(currentCoins, for: \.coins)
            }
        }

        updateGamePoints()
        return coinsEarned
    }

    /// handle ball missing
    public func calculateMissing() {
        winningSteak = .zero
        lives -= 1
        updateGameLives()
    }

    /// handle game completion
    public func completeGame(mode: GameMode) {
        // Game completion logic can be added here if needed
    }

    /// seed ball on frame arbitrarily
    private func seedBall(on frame: CGRect) {
        alignment = .random(.center)
        baseLine = frame.minY + 200
        let ballPosition = CGPoint(
            x: frame.midX + alignment.offset(frame.width) + .tolerance(for: 20),
            y: baseLine
        )
        ball = Ball(location: ballPosition)
    }

    /// seed hoop on frame arbitrarily
    private func seedHoop(on frame: CGRect, for index: Int = 3) {
        let previous = alignment
        alignment = .random(alignment)
        let x = frame.midX + alignment.offset(frame.width) + .tolerance(for: 10)
        let y = baseLine + 280 * CGFloat(index) + .tolerance(for: 20)
        var degree = alignment.degree
        let isDynamic = Bool.random()
        if alignment == .center {
            degree += -previous.degree
        }
        let hoopPosition = CGPoint(x: x, y: y)
        let hoop = Hoop(
            location: hoopPosition,
            degree: degree,
            isDynamic: isDynamic,
            alignment: alignment
        )
        hoops.append(hoop)
    }
}
