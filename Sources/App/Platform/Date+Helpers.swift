import Foundation

extension Date {

    static let daysInWeek = 7

    private var calendar: Calendar {
        return Calendar.current
    }

    var day: Int {
        return calendar.component(.day, from: self)
    }

    var isThisWeek: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    var startOfDay: Date {
        return calendar.startOfDay(for: self)
    }

    var startOfWeek: Date {
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                     from: self)
        return calendar.date(from: dateComponents) ?? self
    }

    var endOfWeek: Date {
        return calendar.date(byAdding: .weekOfYear,
                             value: 1,
                             to: startOfWeek) ?? self
    }

    var daysInMonth: Int {
        return calendar.range(of: .day, in: .month, for: self)?.count ?? 0
    }

    var weeksInMonth: Double {
        return Double(daysInMonth) / Double(Date.daysInWeek)
    }

    func set(day: Int) -> Date {
        var components = calendar.dateComponents([.year, .month], from: self)
        components.day = day
        return calendar.date(from: components) ?? self
    }

    func add(day: Int) -> Date {
        guard day != 0 else { return self }
        return calendar.date(byAdding: .day,
                             value: day,
                             to: self) ?? self
    }

    func add(month: Int) -> Date {
        guard month != 0 else { return self }
        return calendar.date(byAdding: .month,
                             value: month,
                             to: self) ?? self
    }

    func next(day: Int, direction: Calendar.SearchDirection) -> Date {
        let monthModifier: Int

        switch direction {
        case .forward: monthModifier = self.day >= day ? 1 : 0
        case .backward: monthModifier = self.day < day ? -1 : 0
        }

        return self.add(month: monthModifier).set(day: day).startOfDay
    }

    func numberOfDays(from: Date) -> Int {
        return calendar.dateComponents([.day], from: from.startOfDay, to: self.startOfDay).day ?? 0
    }

}