//
//  ContentView.swift
//  bloodmoon
//
//  Created by Daria Kolodzey on 2/19/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                CycleProgressView(cycleLength: 31, cycleDay: 25).padding()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Log period")
                })
                CalendarView(month: Date(), isPeriod: {(_)->Bool in false}, isToday: Calendar.current.isDateInToday).padding(EdgeInsets(top: 20, leading: 60, bottom: 50, trailing: 60))
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
        ContentView()
    }
}
