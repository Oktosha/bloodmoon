//
//  SettingsView.swift
//  bloodmoon
//
//  Created by Daria Kolodzey on 2/19/21.
//

import SwiftUI

struct SettingsView: View {
    
    
    @State private var cycleLength = "\(UserDefaults.standard.object(forKey: "cycleLength") as? Int ?? 28)"
    @State private var periodLength = "\(UserDefaults.standard.object(forKey: "periodLength") as? Int ?? 5)"
    
    @FetchRequest(entity: Cycle.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \Cycle.startDate, ascending: false),])
    var cycles: FetchedResults<Cycle>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cycle and period lengths")) {
                    TextField("Cycle length", text: $cycleLength, onEditingChanged: {_ in
                        UserDefaults.standard.set(Int(cycleLength) ?? 28, forKey: "cycleLength")
                        
                    })
                    .keyboardType(.numberPad)
                    TextField("Period length", text: $periodLength, onEditingChanged: {_ in
                        UserDefaults.standard.set(Int(periodLength) ?? 5, forKey: "periodLength")
                    })
                    .keyboardType(.numberPad)
                }
                Section(header: Text("All your cycle start dates, swipe to delete")) {
                    List {
                        ForEach(cycles) { cycle -> Text in
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "d MMM y"
                            return Text(dateFormatter.string(from:cycle.startDate!))
                        }.onDelete { indexSet in
                            for index in indexSet {
                                viewContext.delete(cycles[index])
                            }
                            do {
                                try viewContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }.navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
