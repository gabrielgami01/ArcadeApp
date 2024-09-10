import Foundation

extension Date {
    func timeDifference(to currentDate: Date = Date()) -> String {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.weekOfYear, .day, .hour], from: self, to: currentDate)
        
        if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks) week(s) ago"
        } else if let days = components.day, days > 0 {
            return "\(days) day(s) ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hour(s) ago"
        } else {
            return "Just now"
        }
    }
}
