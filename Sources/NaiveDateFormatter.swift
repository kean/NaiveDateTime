// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import Foundation


// MARK: - NaiveDateFormatter -

/// Formatting without time zones.
public final class NaiveDateFormatter {
    private let formatter = DateFormatter()

    public init(_ closure: (_ formatter: DateFormatter) -> Void) {
        closure(formatter)
        self.formatter.timeZone = TimeZone._utc // important! UTC to UTC
    }

    public convenience init(format: String) {
        self.init {
            $0.dateFormat = format
        }
    }

    public convenience init(dateStyle: DateFormatter.Style = .none, timeStyle: DateFormatter.Style = .none) {
        self.init {
            $0.dateStyle = dateStyle
            $0.timeStyle = timeStyle
        }
    }

    public func string(from value: NaiveDate) -> String? {
        return formatter.calendar._utcDate(from: value).map { formatter.string(from: $0) }
    }

    public func string(from value: NaiveTime) -> String? {
        return formatter.calendar._utcDate(from: value).map { formatter.string(from: $0) }
    }

    public func string(from value: NaiveDateTime) -> String? {
        return formatter.calendar._utcDate(from: value).map { formatter.string(from: $0) }
    }
}


// MARK: - NaiveDateRangeFormatter -

/// Formatting without time zones.
public final class NaiveDateRangeFormatter {
    private let formatter = DateIntervalFormatter()

    public init(_ closure: (_ formatter: DateIntervalFormatter) -> Void) {
        closure(formatter)
        self.formatter.timeZone = TimeZone._utc // important! UTC to UTC
    }

    public convenience init(format: String) {
        self.init {
            $0.dateTemplate = format
        }
    }

    public convenience init(dateStyle: DateIntervalFormatter.Style = .none, timeStyle: DateIntervalFormatter.Style = .none) {
        self.init {
            $0.dateStyle = dateStyle
            $0.timeStyle = timeStyle
        }
    }

    public func string(from start: NaiveDate, to end: NaiveDate) -> String? {
        return formatter.calendar._utcDateRange(from: start, to: end).map { formatter.string(from: $0, to: $1) }
    }

    public func string(from start: NaiveTime, to end: NaiveTime) -> String? {
        return formatter.calendar._utcDateRange(from: start, to: end).map { formatter.string(from: $0, to: $1) }
    }

    public func string(from start: NaiveDateTime, to end: NaiveDateTime) -> String? {
        return formatter.calendar._utcDateRange(from: start, to: end).map { formatter.string(from: $0, to: $1) }
    }
}


// MARK: - Private -

private extension TimeZone {
    static let _utc = TimeZone(secondsFromGMT: 0)!
}

private extension Calendar {
    func _utcDate<T: _DateComponentsConvertible>(from date: T) -> Date? {
        return self._date(from: date, in: TimeZone._utc)
    }

    func _utcDateRange<T: _DateComponentsConvertible>(from start: T, to end: T) -> (Date, Date)? {
        guard let start = _date(from: start), let end = _date(from: end) else { return nil }
        return (start, end)
    }
}
