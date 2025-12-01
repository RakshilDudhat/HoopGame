import Foundation
import Defaults
import Model

public class DailyChallengeManager {
    private let userDefaults: UserDefaultService
    
    public init(userDefaults: UserDefaultService) {
        self.userDefaults = userDefaults
    }
    
    /// Check if Daily Challenge can be played today
    public var canPlayDailyChallenge: Bool {
        let lastPlayedDateString = userDefaults.fetch(for: \.lastDailyChallengeDate)
        guard !lastPlayedDateString.isEmpty else {
            // Never played before, can play
            return true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        
        guard let lastPlayedDate = dateFormatter.date(from: lastPlayedDateString) else {
            // Invalid date format, allow play
            return true
        }
        
        let today = Date()
        let calendar = Calendar.current
        
        // Check if last played date is today
        return !calendar.isDate(lastPlayedDate, inSameDayAs: today)
    }
    
    /// Record that Daily Challenge was played today
    public func recordDailyChallengePlayed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let todayString = dateFormatter.string(from: Date())
        userDefaults.save(todayString, for: \.lastDailyChallengeDate)
    }
    
    /// Get the date when Daily Challenge was last played (formatted string)
    public var lastPlayedDateString: String {
        let lastPlayedDateString = userDefaults.fetch(for: \.lastDailyChallengeDate)
        guard !lastPlayedDateString.isEmpty else {
            return "Never"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        
        guard let date = dateFormatter.date(from: lastPlayedDateString) else {
            return "Never"
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        return displayFormatter.string(from: date)
    }
}

