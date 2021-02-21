//
//  AddCycleView.swift
//  bloodmoon
//
//  Created by Daria Kolodzey on 2/21/21.
//

import SwiftUI

struct AddCycleView: View {
    @State private var date: Date = Date()
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker(
                    "Cycle Start Date",
                    selection: $date,
                    in: ...Date(),
                    displayedComponents: [.date]
                )
                Button(action: {
                    let newCycle = Cycle(context: viewContext)
                    newCycle.startDate = date
                    do {
                        try viewContext.save()
                        print("Cycle saved.")
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }, label: {
                    Text("Add")
                })
            }.navigationTitle("Log Period")
        }
    }
}

struct AddCycleView_Previews: PreviewProvider {
    static var previews: some View {
        AddCycleView()
    }
}
