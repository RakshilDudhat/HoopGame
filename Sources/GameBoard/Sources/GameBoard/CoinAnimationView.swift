import SwiftUI
import DesignSystem

struct CoinAnimationView: View {
    let coins: Int
    let position: CGPoint
    
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "dollarsign.circle.fill")
                .foregroundColor(.yellow)
                .font(.title2)
            Text("+\(coins)")
                .font(.of(.button))
                .foregroundColor(.yellow)
                .fontWeight(.bold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.4))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .scaleEffect(scale)
        .opacity(opacity)
        .offset(y: offset)
        .position(x: position.x, y: position.y)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                scale = 1.0
            }
            
            withAnimation(.easeOut(duration: 1.5)) {
                offset = -80
            }
            
            withAnimation(.easeOut(duration: 1.0).delay(0.5)) {
                opacity = 0
            }
        }
    }
}


