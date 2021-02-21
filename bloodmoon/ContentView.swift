//
//  ContentView.swift
//  bloodmoon
//
//  Created by Daria Kolodzey on 2/19/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var showLogSheet = false
    
    @FetchRequest(entity: Cycle.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Cycle.startDate, ascending: false),
])
    var cycles: FetchedResults<Cycle>
    
    var currentCycleStartDate: Date? {
        if cycles.count < 1 {
            return nil
        }
        return cycles[0].startDate
    }
    
    var currentCycleDay: Int? {
        if currentCycleStartDate == nil {
            return nil
        }
        return Calendar.current.dateComponents([.day], from: currentCycleStartDate!, to: Date()).day! + 1
    }
    
    @AppStorage("cycleLength") var cycleLength = 28
    @AppStorage("periodLength") var periodLength = 5
    
    func isPeriod(date: Date) -> Bool {
        if currentCycleStartDate == nil {
            return false
        }
        for cycle in cycles {
            let distance = Calendar.current.dateComponents([.day], from: cycle.startDate!, to: date).day!
            if (0 <= distance && distance < periodLength - 1) {
                print("\(date) \(distance)")
                return true;
            }
        }
        let distance = Calendar.current.dateComponents([.day], from: currentCycleStartDate!, to: date).day!
        return distance + 1 > 0 && (distance + 1) % cycleLength < periodLength
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CycleProgressView(cycleLength: cycleLength, cycleDay: currentCycleDay).padding()
                Button(action: {
                    showLogSheet = true
                }, label: {
                    Text("Log period")
                }).sheet(isPresented: $showLogSheet, content: {
                    AddCycleView()
                })
                CalendarView(month: Date(), isPeriod: isPeriod, isToday: Calendar.current.isDateInToday).padding(EdgeInsets(top: 20, leading: 60, bottom: 50, trailing: 60))
            }.navigationBarItems(trailing: NavigationLink(
                                    destination: SettingsView(),
                                    label: {
                                        Image(systemName: "gear")
                                    }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
