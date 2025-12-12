//
//  Date+ParsingFormatting.swift
//  Utils-iOS
//
//  Created by IgniteCoders on 10/03/24.
//
//  Deterministic parsing/formatting (fixed-format and ISO 8601) and
//  user-facing/relative formatting helpers for Date.
//

import Foundation

extension Date {
    
    // MARK: - Formatter defaults
    
    /// The library’s default date-format pattern used by parsing and formatting helpers.
    ///
    /// This pattern is intended to be used with `en_US_POSIX` locale and UTC time zone
    /// for deterministic behavior, matching the defaults in `init(string:format:locale:timeZone:)`
    /// and `toString(format:locale:timeZone:)`.
    public static let defaultFormat = "yyyy-MM-dd HH:mm:ss"
    
    /// The library’s default locale used by parsing and formatting helpers.
    ///
    /// Uses `en_US_POSIX` for deterministic, locale-agnostic behavior across devices.
    /// See Apple’s “Technical Q&A QA1480” for why `en_US_POSIX` is recommended for fixed-format dates.
    public static let defaultLocale: Locale = Locale(identifier: "en_US_POSIX")
    
    /// The library’s default time zone used by parsing and formatting helpers.
    ///
    /// Uses UTC to avoid ambiguity and daylight saving differences across regions.
    public static let defaultTimeZone: TimeZone = TimeZone(secondsFromGMT: 0)!
    
    /// Creates and configures a `DateFormatter` for deterministic parsing/formatting.
    ///
    /// - Parameters:
    ///   - format: A fixed-format pattern string. Defaults to `Date.defaultFormat`.
    ///   - locale: Locale to apply. Defaults to `Date.defaultLocale` (`en_US_POSIX`).
    ///   - timeZone: Time zone to apply. Defaults to `Date.defaultTimeZone` (UTC).
    /// - Returns: A `DateFormatter` configured with the supplied parameters.
    /// - Important: `DateFormatter` is not thread-safe. This method returns a new instance per call.
    static func makeFormatter(format: String = Date.defaultFormat,
                              locale: Locale = Date.defaultLocale,
                              timeZone: TimeZone = Date.defaultTimeZone) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter
    }
    
    // MARK: - Fixed-format parsing and formatting
    
    /// Creates a `Date` by parsing a string with the given date format.
    ///
    /// - Parameters:
    ///   - string: The date string to parse.
    ///   - format: The fixed-format pattern used by `DateFormatter`. Defaults to `Date.defaultFormat`.
    ///   - locale: Locale to use. Defaults to `Date.defaultLocale` (`en_US_POSIX`).
    ///   - timeZone: Time zone to use. Defaults to `Date.defaultTimeZone` (UTC).
    /// - Returns: `nil` if the string cannot be parsed with the supplied format and settings.
    /// - Note: Prefer using fixed-format patterns with `en_US_POSIX` for stable parsing across user locales.
    public init?(string: String,
                 format: String = Date.defaultFormat,
                 locale: Locale = Date.defaultLocale,
                 timeZone: TimeZone = Date.defaultTimeZone) {
        let formatter = Date.makeFormatter(format: format, locale: locale, timeZone: timeZone)
        guard let date = formatter.date(from: string) else {
            return nil
        }
        self = date
    }
    
    /// Formats the date as a string using a fixed-format pattern.
    ///
    /// Deterministic by default: this method uses `en_US_POSIX` as the locale and UTC as the time zone,
    /// so the output does not change with the user’s device settings. This is ideal for:
    /// - Machine-readable/API payloads
    /// - Logging
    /// - Snapshot/Golden-file tests
    ///
    /// For user-facing, localized strings, either:
    /// - Use `formatted(dateStyle:timeStyle:locale:timeZone:)`, or
    /// - Pass `locale: .current` and `timeZone: .current` explicitly here.
    ///
    /// - Parameters:
    ///   - format: The fixed-format pattern used by `DateFormatter`. Defaults to `Date.defaultFormat`.
    ///   - locale: Locale to use. Defaults to `Date.defaultLocale` (`en_US_POSIX`) for deterministic output.
    ///   - timeZone: Time zone to use. Defaults to `Date.defaultTimeZone` (UTC) for deterministic output.
    /// - Returns: A formatted date string.
    public func toString(format: String = Date.defaultFormat,
                         locale: Locale = Date.defaultLocale,
                         timeZone: TimeZone = Date.defaultTimeZone) -> String {
        let formatter = Date.makeFormatter(format: format, locale: locale, timeZone: timeZone)
        return formatter.string(from: self)
    }
    
    /// Formats the date using `DateFormatter` dateStyle/timeStyle presets (user-facing).
    ///
    /// - Parameters:
    ///   - dateStyle: Date style. Defaults to `.medium`.
    ///   - timeStyle: Time style. Defaults to `.medium`.
    ///   - locale: Locale to use. Defaults to `.current`.
    ///   - timeZone: Time zone to use. Defaults to `.current`.
    /// - Returns: A localized, user-friendly date string.
    public func formatted(dateStyle: DateFormatter.Style = .medium,
                          timeStyle: DateFormatter.Style = .medium,
                          locale: Locale = .current,
                          timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
    // MARK: - ISO 8601 / RFC 3339
    
    /// Creates a `Date` by parsing an ISO 8601 / RFC 3339 string.
    ///
    /// - Parameters:
    ///   - string: The ISO 8601 / RFC 3339 date string to parse.
    ///   - timeZone: Time zone to use. Defaults to `Date.defaultTimeZone` (UTC).
    /// - Note: This initializer first attempts to parse with fractional seconds and then falls back to parsing without them.
    public init?(iso8601 string: String,
                 timeZone: TimeZone = Date.defaultTimeZone) {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = timeZone
        // Options to handle fractional seconds if present
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let dateWithFractionalSeconds = formatter.date(from: string) {
            self = dateWithFractionalSeconds
            return
        }
        // Fallback without fractional seconds
        formatter.formatOptions = [.withInternetDateTime]
        guard let dateWithoutFractionalSeconds = formatter.date(from: string) else { return nil }
        self = dateWithoutFractionalSeconds
    }
    
    /// Formats the date into an ISO 8601 (RFC 3339) string.
    ///
    /// - Parameters:
    ///   - includeFractionalSeconds: Whether to include fractional seconds in the output. Defaults to `true`.
    ///   - timeZone: Time zone to use. Defaults to `Date.defaultTimeZone` (UTC).
    /// - Returns: An ISO 8601 compliant string.
    public func toISO8601String(includeFractionalSeconds: Bool = true,
                                timeZone: TimeZone = Date.defaultTimeZone) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = timeZone
        formatter.formatOptions = includeFractionalSeconds ? [.withInternetDateTime, .withFractionalSeconds] : [.withInternetDateTime]
        return formatter.string(from: self)
    }
    
    // MARK: - Relative
    
    /// A human-readable relative time description (e.g., "5 min ago", "in 2 hours").
    ///
    /// - Parameters:
    ///   - reference: The date to compare against. Defaults to `.now`.
    ///   - locale: Locale to use. Defaults to `.current`.
    /// - Returns: A localized, relative time string.
    public func relativeDescription(reference: Date = .now, locale: Locale = .current) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = locale
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: reference)
    }
}
