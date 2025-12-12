//
//  Date+CalendarMath.swift
//  Utils-iOS
//
//  Created by IgniteCoders on 10/03/24.
//
//  Calendar-based boundaries and arithmetic helpers for Date.
//

import Foundation

extension Date {
    
    // MARK: - Calendar boundaries and arithmetic
    
    /// The start of the day containing this date, using the provided calendar.
    ///
    /// - Parameter calendar: Calendar to use. Defaults to `.current`.
    /// - Returns: A `Date` representing the start of the day (usually 00:00:00).
    public func startOfDay(calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: self)
    }
    
    /// The end of the day containing this date, using the provided calendar.
    ///
    /// Implemented as one second before the start of the next day.
    ///
    /// - Parameter calendar: Calendar to use. Defaults to `.current`.
    /// - Returns: A `Date` representing the end of the day (e.g., 23:59:59 in many calendars).
    public func endOfDay(calendar: Calendar = .current) -> Date {
        let start = startOfDay(calendar: calendar)
        // Add 1 day, subtract 1 second to get end of day
        return calendar.date(byAdding: DateComponents(day: 1, second: -1), to: start) ?? self
    }
    
    /// The start of the week containing this date, based on the calendar’s firstWeekday.
    ///
    /// - Parameter calendar: Calendar to use. Defaults to `.current`.
    /// - Returns: A `Date` representing the start of the week.
    public func startOfWeek(calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// The start of the month containing this date.
    ///
    /// - Parameter calendar: Calendar to use. Defaults to `.current`.
    /// - Returns: A `Date` representing the first moment of the month.
    public func startOfMonth(calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// The end of the month containing this date.
    ///
    /// Implemented as one second before the start of the next month.
    ///
    /// - Parameter calendar: Calendar to use. Defaults to `.current`.
    /// - Returns: A `Date` representing the last moment of the month.
    public func endOfMonth(calendar: Calendar = .current) -> Date {
        let start = startOfMonth(calendar: calendar)
        var comps = DateComponents()
        comps.month = 1
        comps.second = -1
        return calendar.date(byAdding: comps, to: start) ?? self
    }
    
    /// Returns a new date by adding the specified components to this date.
    ///
    /// - Parameters:
    ///   - days: Number of days to add (negative to subtract). Defaults to `0`.
    ///   - hours: Number of hours to add (negative to subtract). Defaults to `0`.
    ///   - minutes: Number of minutes to add (negative to subtract). Defaults to `0`.
    ///   - seconds: Number of seconds to add (negative to subtract). Defaults to `0`.
    ///   - calendar: Calendar to use. Defaults to `.current`.
    /// - Returns: A new `Date` with the applied offset, or `self` if the operation fails.
    public func adding(days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0, calendar: Calendar = .current) -> Date {
        var comps = DateComponents()
        comps.day = days
        comps.hour = hours
        comps.minute = minutes
        comps.second = seconds
        return calendar.date(byAdding: comps, to: self) ?? self
    }
    
    /// Difference in full calendar days between this date and another date.
    ///
    /// The calculation is based on the start of each day in the provided calendar
    /// to avoid partial-day effects due to time or time zone.
    ///
    /// - Parameters:
    ///   - other: The date to compare to.
    ///   - calendar: Calendar to use. Defaults to `.current`.
    /// - Returns: The number of full days between `other` and `self` (positive if `self` is later).
    public func days(since other: Date, calendar: Calendar = .current) -> Int? {
        let startSelf = calendar.startOfDay(for: self)
        let startOther = calendar.startOfDay(for: other)
        return calendar.dateComponents([.day], from: startOther, to: startSelf).day
    }
}
