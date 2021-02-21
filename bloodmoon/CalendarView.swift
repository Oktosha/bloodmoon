//
//  CalendarView.swift
//  bloodmoon
//
//  Created by Daria Kolodzey on 2/19/21.
//

import SwiftUI

struct CalendarView: View {
    @State var month: Date
    let isPeriod: (Date) -> Bool
    let isToday: (Date) -> Bool
    var body: some View {
        VStack {
            MonthView(month: month, isPeriod: {(_)->Bool in false}, isToday: Calendar.current.isDateInToday)
            Spacer()
            HStack {
                Button(action: {shiftMonth(delta: -1)}, label: {
                    Image(systemName: "chevron.left")
                })
                MonthTextView(month: month)
                Button(action: {shiftMonth(delta: 1)}, label: {
                    Image(systemName: "chevron.right")
                })
            }
        }
    }
    func shiftMonth(delta: Int) {
        month = Calendar.current.date(byAdding: .month, value: delta, to: month)!
    }
}

struct MonthTextView: View {
    let month: Date
    var body: some View {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "MMM, yyyy"
        return Text(myFormatter.string(from: month))
    }
}

struct MonthView : View {
    let month: Date
    var lastMondayOfPreviousMonth: Date {
        let currentMonthDateComponents = Calendar.current.dateComponents([.month, .year], from: month)
        let currentMonth = currentMonthDateComponents.month!
        let previousMonth = currentMonth - 1 > 0
            ? currentMonth - 1
            : 12
        let previousMonthYear = currentMonth - 1 > 0
            ? currentMonthDateComponents.year!
            : currentMonthDateComponents.year! - 1
        return Calendar.current.date(from: DateComponents(
            year: previousMonthYear,
            month: previousMonth,
            weekday: 2,
            weekdayOrdinal: -1
        ))!
    }
    let isPeriod: (Date) -> Bool
    let isToday: (Date) -> Bool
    var body: some View {
        VStack {
            ForEach(0..<6) {
                WeekView(startDate: lastMondayOfPreviousMonth + TimeInterval(60 * 60 * 24 * 7 * $0), isPeriod: {(date: Date) -> Bool in false}, isToday: Calendar.current.isDateInToday)
                if ($0 < 5) {
                    Spacer()
                }
            }
        }
    }
}

struct WeekView : View {
    let startDate: Date
    let isPeriod: (Date) -> Bool
    let isToday: (Date) -> Bool
    var body: some View {
        HStack {
            ForEach((0..<7)) {
                let shift = TimeInterval(60 * 60 * 24 * $0)
                let date = startDate + shift
                let day = Calendar.current.dateComponents([.day], from: date).day!
                DayView("\(day)", isPeriod: isPeriod(date), isToday: isToday(date))
                if ($0 < 6) {
                    Spacer()
                }
            }
        }
    }
}

struct DayView: View {
    let isPeriod: Bool
    let isToday: Bool
    let day: String
    init(_ day: String, isPeriod: Bool, isToday: Bool) {
        self.day = day
        self.isPeriod = isPeriod
        self.isToday = isToday
    }
    init(_ day: String, isPeriod: Bool) {
        self.day = day
        self.isPeriod = isPeriod
        self.isToday = false
    }
    init(_ day: String, isToday: Bool) {
        self.day = day
        self.isPeriod = false
        self.isToday = isToday
    }
    init(_ day: String) {
        self.day = day
        self.isPeriod = false
        self.isToday = false
    }
    var body: some View {
        if isToday {
            if isPeriod {
                Text(day)
                    .bold()
                    .foregroundColor(.red)
                    .background(
                        EmptyCircle().frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    ).frame(width: 35, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            } else {
                Text(day)
                    .background(
                        EmptyCircle().frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    ).frame(width: 35, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        } else {
            if isPeriod {
                Text(day).bold().foregroundColor(.red)
                    .frame(width: 35, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            } else {
                Text(day)
                    .frame(width: 35, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct EmptyCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addArc(center: CGPoint(x: rect.midX, y:rect.midY), radius: min(rect.height, rect.width) / 2, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
        return p.strokedPath(StrokeStyle(lineWidth: 2))
    }
    
    
}
