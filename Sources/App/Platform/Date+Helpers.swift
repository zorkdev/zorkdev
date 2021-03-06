import Foundation

let calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_GB")
    calendar.timeZone = TimeZone(identifier: "Europe/London")!
    return calendar
}()

extension Date {
    static let daysInWeek = 7

    var day: Int {
        calendar.component(.day, from: self)
    }

    var startOfDay: Date {
        calendar.startOfDay(for: self)
    }

    var startOfWeek: Date {
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                     from: self)
        return calendar.date(from: dateComponents) ?? self
    }

    var endOfWeek: Date {
        calendar.date(byAdding: .weekOfYear,
                      value: 1,
                      to: startOfWeek) ?? self
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
        @unknown default: monthModifier = 0
        }

        return self.add(month: monthModifier).set(day: day).startOfDay
    }

    func numberOfDays(from: Date) -> Int {
        calendar.dateComponents([.day], from: from.startOfDay, to: self.startOfDay).day ?? 0
    }
}
