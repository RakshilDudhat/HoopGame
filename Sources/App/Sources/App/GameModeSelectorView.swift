import SwiftUI
import Routing
import Model
import DesignSystem
import Core

struct GameModeSelectorView: View {
    @Coordinator var coordinator
    let dailyChallengeManager: DailyChallengeManager

    private let cards: [ModeCard] = ModeCard.all

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    header
                    ForEach(cards) { card in
                        modeCard(card)
                    }
                }
                .padding(24)
            }
            .background(
                Image.loadImage(.doodleArt)
                    .renderingMode(.template)
                    .foregroundColor(.of(.peach).opacity(0.2))
                    .ignoresSafeArea()
            )
            .background(Color.of(.deepChampagne), ignoresSafeAreaEdges: .all)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        $coordinator.dismiss()
                    } label: {
                        Image.loadImage(.xmarkCircleFill)
                    }
                    .buttonStyle(.default)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Choose Your Run")
                .font(.of(.heading))
                .foregroundColor(.of(.rust))
            Text("Earn coins, unlock balls, and build your collection!")
                .font(.of(.headline))
                .foregroundColor(.of(.mahogany))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

private func modeCard(_ card: ModeCard) -> some View {
        let isDailyChallenge = card.mode == .dailyChallenge
        let canPlayDailyChallenge = dailyChallengeManager.canPlayDailyChallenge
        let isDisabled = isDailyChallenge && !canPlayDailyChallenge
        
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.title)
                        .font(.of(.headline))
                        .foregroundColor(.of(.eerieBlack))
                    Text(card.subtitle)
                        .font(.of(.caption))
                        .foregroundColor(.of(.mahogany))
                }
                Spacer()
                Image.loadImage(card.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .opacity(1.0)
            }
            Text(card.description)
                .font(.of(.caption2))
                .foregroundColor(.of(.eerieBlack))
            
            Button {
                // Double-check before starting Daily Challenge
                if isDailyChallenge && !dailyChallengeManager.canPlayDailyChallenge {
                    return // Prevent navigation if already played
                }
                $coordinator.switchScreen(.gameBoard(mode: card.mode))
                $coordinator.dismiss()
            } label: {
                Label {
                    Text(isDisabled ? "Locked" : card.cta)
                } icon: {
                    Image.loadImage(isDisabled ? .lockFill : .gamecontrollerFill)
                }
            }
            .buttonStyle(.primary)
            .opacity(isDisabled ? 0.5 : 1.0)
            .disabled(isDisabled)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(card.backgroundColor)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
    }
}

private struct ModeCard: Identifiable {
    let id = UUID()
    let icon: Icons
    let title: String
    let subtitle: String
    let description: String
    let cta: String
    let mode: GameMode
    let backgroundColor: Color

    static var all: [ModeCard] {
        [
            ModeCard(
                icon: .gamecontrollerFill,
                title: "Classic Run",
                subtitle: "Three lives, climb the ladder",
                description: "Your standard Hoop experience. Build streaks, chase trophies, and earn coins to unlock new balls in the shop!",
                cta: "Start Classic Run",
                mode: .new,
                backgroundColor: Color.of(.deepChampagne)
            ),
            ModeCard(
                icon: .flameFill,
                title: "Daily Challenge",
                subtitle: "One life. Big rewards.",
                description: "Limited attempts with a tougher baseline. Earn bonus coins to unlock premium balls faster! Play once per day.",
                cta: "Take the Challenge",
                mode: .dailyChallenge,
                backgroundColor: Color.of(.peach)
            ),
            ModeCard(
                icon: .infinity,
                title: "Endless Run",
                subtitle: "More lives, more chaos",
                description: "Extra cushion on misses so you can experiment with wild shots and trick plays. Practice mode - no coins earned.",
                cta: "Go Endless",
                mode: .endless,
                backgroundColor: Color.of(.nonPhotoBlue)
            )
        ]
    }
}

