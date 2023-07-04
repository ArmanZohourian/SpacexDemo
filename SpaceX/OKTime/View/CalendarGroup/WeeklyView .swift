//
//  WeeklyView .swift
//  OKTime
//
//  Created by Arman Zohourian on 11/10/22.
//

import SwiftUI

struct Weeklyday<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let week: Date
    let content: (Date) -> DateView

    init(week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }

    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: week)
            else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        HStack(spacing: 37) {
            ForEach(days, id: \.self) { date in
                HStack() {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .weekOfYear) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}
