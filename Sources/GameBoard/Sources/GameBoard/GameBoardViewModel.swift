import Core
import Model
import Combine
import SwiftUI

class GameBoardViewModel: ObservableObject {
    let dependency: GameBoardDependency

    @Published var gameState: GameState = .idle
    @Published var points: Int = .zero
    @Published var winningSteak: Int = .zero
    @Published var lives: Int = .zero
    @Published var coinsEarned: Int? = nil
    @Published var coinAnimationPosition: CGPoint = .zero

    lazy private(set) var restartTrigger = PassthroughSubject<Void, Never>()
    lazy private(set) var airBallTrigger = PassthroughSubject<Void, Never>()

    var timer: AnyCancellable?

    var ball: Ball { dependency.gameManager.ball }
    var hoops: Hoops { dependency.gameManager.hoops }

    let ballStyle: BallStyle

    private var cancellables = Set<AnyCancellable>()

    public init(dependency: GameBoardDependency) {
        self.dependency = dependency
        self.ballStyle = dependency.userDefaults.fetch(for: \.ball)
    }

    func loadGame(on frame: CGRect, mode: GameMode) {
        dependency.gameManager.loadGame(on: frame, mode: mode)
        points = dependency.gameManager.points
        winningSteak = dependency.gameManager.winningSteak
        lives = dependency.gameManager.lives
    }

    func prepareForNextRound(on frame: CGRect, with location: CGPoint) {
        dependency.gameManager.prepareForNextRound(on: frame, with: location)
    }

    func restartGame(action: @escaping () -> Void) {
        restartTrigger
            .sink(receiveValue: action)
            .store(in: &cancellables)
    }

    func handleAirBall(action: @escaping () -> Void) {
        airBallTrigger
            .sink(receiveValue: action)
            .store(in: &cancellables)
    }

    func calculatePoints(_ count: Int, isBankShot: Bool, hoopPosition: CGPoint = .zero) {
        let coinsEarned = dependency.gameManager.calculatePoints(count, isBankShot: isBankShot, gameMode: dependency.gameMode)
        let gainedPoints = dependency.gameManager.points - self.points
        withAnimation {
            let animationDuration = 500
            let steps = min(abs(gainedPoints), 100)
            let stepDuration = (animationDuration / steps)
            self.points += gainedPoints % steps
            (0..<steps).forEach { step in
                let updateTimeInterval = DispatchTimeInterval.milliseconds(step * stepDuration)
                let deadline = DispatchTime.now() + updateTimeInterval
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    self.points += Int(gainedPoints / steps)
                }
            }
        }
        self.winningSteak = dependency.gameManager.winningSteak
        
        // Show coin animation if coins were earned
        if coinsEarned > 0 {
            DispatchQueue.main.async {
                // Convert SpriteKit coordinates (bottom-left origin) to SwiftUI coordinates (top-left origin)
                // We'll get the frame size from the scene later, for now use the position as-is
                self.coinAnimationPosition = hoopPosition
                self.coinsEarned = coinsEarned
                // Hide animation after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.coinsEarned = nil
                }
            }
        }
    }

    func calculateMissing() {
        if dependency.gameMode != .endless {
            dependency.gameManager.calculateMissing()
            winningSteak = .zero
            withAnimation {
                lives -= 1
            }
        }
    }

    func startTimer() {
        let start = Date()
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .map { output in
                output.timeIntervalSince(start)
            }
            .map { timeInterval in
                Int(timeInterval)
            }
            .sink { [weak self] seconds in
                if seconds >= 10 {
                    self?.airBallTrigger.send()
                    self?.cancelTimer()
                }
            }
    }

    func cancelTimer() {
        timer?.cancel()
        timer = nil
    }

    func cleanUpGameBoard() {
        dependency.gameManager.deleteGameObject(mode: dependency.gameMode)
    }

    func pauseGame() {
        withAnimation {
            gameState = .pause
        }
    }

    func resumeGame() {
        withAnimation {
            gameState = .idle
        }
    }

}
