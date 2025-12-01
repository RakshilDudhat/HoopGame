import Model
import Routing
import SwiftUI
import DesignSystem

public struct BallPickerView: View {
    @Coordinator var coordinator
    @StateObject var viewModel: BallPickerViewModel

    public init(dependency: BallPickerDependency) {
        self._viewModel = StateObject(wrappedValue: dependency.viewModel)
    }

    var colums: [GridItem] = {
        Array(
            repeating: GridItem(.flexible(), spacing: 20),
            count: 3
        )
    }()

    public var body: some View {
        VStack(spacing: 0) {
            NavBar(title: "Ball Shop") {
                $coordinator.dismiss()
            }
            .overlay(alignment: .leading) {
                // Coin balance display
                HStack(spacing: 4) {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                    Text(viewModel.coinBalance.formattedShort)
                        .font(.of(.headline))
                        .foregroundColor(.of(.rust))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .padding(.leading, 16)
            }
            
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: colums, spacing: 20) {
                        ForEach(viewModel.balls) { ball in
                            ballGridView(ball, in: proxy)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                }
            }
        }
        .background {
            Image.loadImage(.doodleArt)
                .renderingMode(.template)
                .foregroundColor(.of(.peach).opacity(0.5))
        }
        .background(Color.of(.deepChampagne), ignoresSafeAreaEdges: .all)
        .onAppear {
            viewModel.updateCoinBalance()
        }
    }

    @ViewBuilder
    private func ballGridView(_ ball: BallStyle, in proxy: GeometryProxy) -> some View {
        let size = proxy.size.width / 3 - 40
        let isUnlocked = viewModel.isBallUnlocked(ball)
        let isSelected = ball == viewModel.selectedBall
        let canAfford = viewModel.canAffordBall(ball)

        Button {
            if isUnlocked {
                viewModel.selectBall(ball)
            } else if canAfford {
                if viewModel.purchaseBall(ball) {
                    // Ball purchased successfully, now select it
                    viewModel.selectBall(ball)
                }
            }
        } label: {
            ZStack {
                Image.loadBall(ball.rawValue)
                    .frame(maxWidth: size, minHeight: size)
                    .background(Color.of(.peach))
                    .cornerRadius(15)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(!isUnlocked ? Color.gray.opacity(0.3) : (isSelected ? Color.of(.flame) : Color.gray.opacity(0.3)), lineWidth: 4)
                    }
                    .opacity(isUnlocked ? 1.0 : 0.5)
                    .blur(radius: isUnlocked ? 0 : 1)

                // Lock/price overlay for locked balls
                if !isUnlocked {
                    ZStack {
                        Color.black.opacity(0.4)
                            .cornerRadius(15)

                        VStack(spacing: 6) {
                            if ball.isFree {
                                Image(systemName: "lock.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            } else {
                                VStack(spacing: 2) {
                                    Image(systemName: "dollarsign.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(canAfford ? .yellow : .white)
                                    Text("\(ball.coinPrice)")
                                        .font(.of(.caption))
                                        .foregroundColor(canAfford ? .white : .white)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        
                        VStack {
                            Spacer()
                            if !canAfford && !ball.isFree {
                                Label {
                                    Text("Locked")
                                } icon: {
                                    Image.loadImage(.lockFill)
                                }
                                .font(.of(.caption))
                                .foregroundColor(.of(.rust))
                                .padding(.vertical, 4)
                                .frame(width: size)
                                .background {
                                    Color.white//of(.wheat)
                                        .clipShape(RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight]))
                                }
                                .transition(.scale)
                            } else if canAfford {
                                Text("Tap to buy")
                                    .font(.of(.caption))
                                    .foregroundColor(.of(.rust))
                                    .padding(.vertical, 4)
                                    .frame(width: size)
                                    .background {
                                        Color.white//of(.wheat)
                                            .clipShape(RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight]))
                                    }
                                    .transition(.scale)
                            }
                        }
                    }
                    .frame(maxWidth: size, minHeight: size)
                }
            }
            .frame(maxWidth: size, minHeight: size)
        }
        .buttonStyle(.default)
        .disabled(isSelected || (!isUnlocked && !canAfford))
//        .overlay(alignment: .bottom) {
//
//            if isSelected {
//                Label {
//                    Text("Selected")
//                } icon: {
//                    Image.loadImage(.checkmarkCircleFill)
//                }
//                .font(.of(.caption2))
//                .foregroundColor(.of(.olive))
//                .padding(3)
//                .background {
//                    Capsule()
//                        .foregroundColor(.of(.wheat))
//                }
//                .offset(y: 10)
//                .transition(.scale)
//            } else if isUnlocked {
//                Label {
//                    Text("Owned")
//                } icon: {
//                    Image(systemName: "checkmark.circle")
//                }
//                .font(.of(.caption2))
//                .foregroundColor(.green)
//                .padding(3)
//                .background {
//                    Capsule()
//                        .foregroundColor(.white.opacity(0.8))
//                }
//                .offset(y: 10)
//                .transition(.scale)
//            } 
////            else if canAfford {
////                
////                    Text("Tap to buy")
////                
////                .font(.of(.caption))
////                .foregroundColor(.of(.rust))
////                .padding(.vertical, 4)
////                .frame(width: size)
////                .background {
////                    Color.white//of(.wheat)
////                        .clipShape(RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight]))
////                }
////                .transition(.scale)
////            }
//        }
    }
}


import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = 12
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension Int {
    var formattedShort: String {
        switch self {
        case 1_000_000_000...:
            return String(format: "%.1fB", Double(self) / 1_000_000_000).removeTrailingZero
        case 1_000_000...:
            return String(format: "%.1fM", Double(self) / 1_000_000).removeTrailingZero
        case 1_000...:
            return String(format: "%.1fK", Double(self) / 1_000).removeTrailingZero
        default:
            return "\(self)"
        }
    }
}

private extension String {
    var removeTrailingZero: String {
        self.replacingOccurrences(of: ".0", with: "")
    }
}
