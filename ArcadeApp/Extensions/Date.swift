import SwiftUI

extension Date {
    func timeDifference(to currentDate: Date = Date()) -> LocalizedStringKey {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.weekOfYear, .day, .hour], from: self, to: currentDate)
        
        if let weeks = components.weekOfYear, weeks > 0 {
            return LocalizedStringKey("\(weeks) week(s) ago")
        } else if let days = components.day, days > 0 {
            return LocalizedStringKey("\(days) day(s) ago")
        } else if let hours = components.hour, hours > 0 {
            return LocalizedStringKey("\(hours) hour(s) ago")
        } else {
            return LocalizedStringKey("Just now")
        }
    }
}
