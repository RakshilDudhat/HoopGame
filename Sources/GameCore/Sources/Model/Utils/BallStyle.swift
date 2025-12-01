import Foundation

public typealias BallStyles = [BallStyle]

public enum BallStyle: String, Codable, Identifiable {
    public var id: String {
        self.rawValue
    }

    public var coinPrice: Int {
        switch self {
        case .basketball: return 0 // Free
        case .niviaBasketball: return 500
        case .vectorXBbasketball: return 1000
        case .oldWilsonBasketball: return 1500
        case .wilsonNbaBasketball: return 2000
        case .blackWilsonBasketball: return 2500
        case .spaldingNbaBasketball: return 3000
        case .sliverWilsonBasketball: return 3500
        case .goldenSpaldingBasketball: return 4000
        case .signedSpaldingBasketball: return 4500
        case .spaldingColorfulBasketball: return 5000
        case .bowling: return 10000
        case .tennis: return 15000
        case .football: return 20000
        case .volleyball: return 25000
        case .soccer: return 30000
        case .beach: return 35000
            
//        case .basketball: return 0 // Free
//        case .niviaBasketball: return 50
//        case .vectorXBbasketball: return 50
//        case .oldWilsonBasketball: return 50
//        case .wilsonNbaBasketball: return 50
//        case .blackWilsonBasketball: return 50
//        case .spaldingNbaBasketball: return 50
//        case .sliverWilsonBasketball: return 50
//        case .goldenSpaldingBasketball: return 50
//        case .signedSpaldingBasketball: return 50
//        case .spaldingColorfulBasketball: return 50
//        case .bowling: return 50
//        case .tennis: return 50
//        case .football: return 50
//        case .volleyball: return 50
//        case .soccer: return 50
//        case .beach: return 50
        }
    }

    public var isFree: Bool {
        coinPrice == 0
    }

    // Basketball variants
    case basketball
    case niviaBasketball = "nivia-basketball"
    case vectorXBbasketball = "vector-x-basketball"
    case oldWilsonBasketball = "old-wilson-basketball"
    case wilsonNbaBasketball = "wilson-nba-basketball"
    case blackWilsonBasketball = "black-wilson-basketball"
    case spaldingNbaBasketball = "spalding-nba-basketball"
    case sliverWilsonBasketball = "sliver-wilson-basketball"
    case goldenSpaldingBasketball = "golden-spalding-basketball"
    case signedSpaldingBasketball = "signed-spalding-basketball"
    case spaldingColorfulBasketball = "spalding-colorful-basketball"

    // Premium balls (coin shop)
    case bowling
    case tennis
    case football
    case volleyball
    case soccer
    case beach
}

public extension BallStyles {
    static let all: [BallStyle] = [
        .basketball,
        .niviaBasketball,
        .vectorXBbasketball,
        .oldWilsonBasketball,
        .wilsonNbaBasketball,
        .spaldingNbaBasketball,
        .spaldingColorfulBasketball,
        .signedSpaldingBasketball,
        .blackWilsonBasketball,
        .sliverWilsonBasketball,
        .goldenSpaldingBasketball
    ]
}
