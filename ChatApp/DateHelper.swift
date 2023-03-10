//
//  DateHelper.swift
//  ChatApp
//
//  Created by Ramananda on 25/2/23.
//

import Foundation


extension Date {
    
    func descriptiveString(dateStyle: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        
        let daysBetween = self.daysBetween(date: Date())
        
        if daysBetween == 0 {
            return "Today"
        }
        
        else if daysBetween == 1 {
            return "Yesterday"
            
        }
        
        else if daysBetween < 5 {
            let weekdayIndex = Calendar.current.component(.weekday, from: self) - 1
            
            return formatter.weekdaySymbols[weekdayIndex]
        }
        
        return formatter.string(from: self)
    }
    
    
    func daysBetween(date : Date) -> Int {
        let calender = Calendar.current
        let date1 = calender.startOfDay(for: self)
        let date2 = calender.startOfDay(for: date)
        
        if let daysBetween = calender.dateComponents([.day], from: date1, to: date2).day {
            return daysBetween
        }
        
        return 0
    }
    
    //March 4, 2023
    
    var currentDateFormat : String {
        self.formatted(
            .dateTime.month(.wide).day(.twoDigits).year(.defaultDigits)
        )
    }
    
    //"22:58 PM"
    
    var currentTimeFormat : String {
        self.formatted(
            .dateTime.hour(.conversationalTwoDigits(amPM: .wide)).minute()
        )
    }
}
