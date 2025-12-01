import Core
import Model
import SwiftUI

class BallPickerViewModel: ObservableObject {
    let dependency: BallPickerDependency
    let balls: BallStyles = .all

    @Published var selectedBall: BallStyle
    @Published var unlockedBalls: [BallStyle] = []
    @Published var coinBalance: Int = 0

    public init(dependency: BallPickerDependency) {
        self.dependency = dependency
        self.selectedBall = dependency.userDefaults.fetch(for: \.ball)
        self.unlockedBalls = dependency.userDefaults.fetch(for: \.unlockedBalls)
        self.coinBalance = dependency.userDefaults.fetch(for: \.coins)
    }

    func isBallUnlocked(_ ball: BallStyle) -> Bool {
        unlockedBalls.contains(ball)
    }

    func selectBall(_ ball: BallStyle) {
        guard isBallUnlocked(ball) else { return }

        withAnimation {
            self.selectedBall = ball
        }
        dependency.userDefaults.save(ball, for: \.ball)
    }

    func canAffordBall(_ ball: BallStyle) -> Bool {
        coinBalance >= ball.coinPrice
    }

    func purchaseBall(_ ball: BallStyle) -> Bool {
        guard !isBallUnlocked(ball) else { return false }
        guard canAffordBall(ball) else { return false }

        // Deduct coins
        let newBalance = coinBalance - ball.coinPrice
        coinBalance = newBalance
        dependency.userDefaults.save(newBalance, for: \.coins)

        // Unlock ball
        var currentUnlocked = unlockedBalls
        currentUnlocked.append(ball)
        unlockedBalls = currentUnlocked
        dependency.userDefaults.save(currentUnlocked, for: \.unlockedBalls)

        return true
    }

    func updateCoinBalance() {
        coinBalance = dependency.userDefaults.fetch(for: \.coins)
    }
}

