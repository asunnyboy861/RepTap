import Foundation

extension Date {
    var formattedShort: String {
        formatted(date: .abbreviated, time: .shortened)
    }

    var formattedDateOnly: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var isThisWeek: Bool {
        Calendar.current.isDate(self, equalTo: .now, toGranularity: .weekOfYear)
    }

    var startOfWeek: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
}
