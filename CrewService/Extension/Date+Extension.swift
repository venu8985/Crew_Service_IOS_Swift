//
//  Date+Extension.swift
//  Alfayda
//
//  Created by Wholly-iOS on 19/09/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit

public enum DateFormatterType: String {
    case serverDateFormate = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
     case requestDate = "EEE, MMM dd, hh:mm a"
    case milestone = "yyyy-MM-dd HH:mm:ss"
     case serverDisplayDateFormate = "dd-MM-yyyy hh:mm a"
    case orderDisplayDate = "MMM dd, yyyy hh:mm a"
    case date = "dd-MM-yyyy"
    case sendDate = "yyyy-MM-dd"
    case dateMMM = "dd MMMM, yyyy"
    case dateDDMM = "dd MMMM"
    case dateTimeMM = "dd MMM, HH:mm"
    case time = "hh:mm a"
    case dateEEE = "EEE,dd MMM, yyyy"
    
}

extension Date {
    
    // Initializes Date from string and format
    public init?(fromUTCString string: String, format: DateFormatterType) {
        self.init(fromUTCString: string, format: format.rawValue)
    }
    
    public init?(fromUTCString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
    public init?(fromLocalString string: String, format: DateFormatterType) {
        self.init(fromLocalString: string, format: format.rawValue)
    }
    
    public init?(fromLocalString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
    // Converts Date to String, with format
    public func toString(format: DateFormatterType, identifier: TimeZone = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = identifier
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    public func toString(format: String, identifier: TimeZone = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = identifier
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    func toLocalTimeZone(format: DateFormatterType)  -> String {
        return self.toString(format: format, identifier: TimeZone.current)
    }
}

extension String {
    
    func toUTCDate(format: DateFormatterType) -> Date? {
        return Date(fromUTCString: self, format: format)
    }
    func toLocalDate(format: DateFormatterType) -> Date? {
        return Date(fromLocalString: self, format: format)
    }
}


extension Date {
    public func timePassed() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])
        
        var str: String
        if components.year! >= 1 {
            components.year == 1 ? (str = Language.get("year")) : (str = Language.get("years"))
            return String(format: components.year!.description+" "+str, components.year!.description)+" "
        } else if components.month! >= 1 {
            components.month == 1 ? (str = Language.get("month")) : (str = Language.get("months"))
            return String(format: components.month!.description+" "+str, components.month!.description)+" "
        } else if components.day! >= 1 {
            components.day == 1 ? (str = Language.get("day")) : (str = Language.get("days"))
            return String(format: components.day!.description+" "+str, components.day!.description)+" "
        } else if components.hour! >= 1 {
            components.hour == 1 ? (str = Language.get("hour")) : (str = Language.get("hours"))
            return String(format: components.hour!.description+" "+str, components.hour!.description)+" "
        } else if components.minute! >= 1 {
            components.minute == 1 ? (str = Language.get("minute")) : (str = Language.get("minutes"))
            return String(format: components.minute!.description+" "+str, components.minute!.description)+" "
        } else if components.second! >= 1 {
            components.second == 1 ? (str = Language.get("second")) : (str = Language.get("seconds"))
            return String(format: components.second!.description+" "+str, components.second!.description)+" "
        } else {
            return Language.get("Just now")
        }
    }
    func toAge() -> Int {
        let now = Date()
        let ageComponents = Calendar.current.dateComponents([.year], from: self, to: now)
        return ageComponents.year ?? 0
    }
    func toAgeDays() -> Int {
        let now = Date()
        let ageComponents = Calendar.current.dateComponents([.day], from: now, to: self)
        return ageComponents.day ?? 0
    }
}
