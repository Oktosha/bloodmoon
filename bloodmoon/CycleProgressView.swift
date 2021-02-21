//
//  CycleProgressView.swift
//  bloodmoon
//
//  Created by Daria Kolodzey on 2/19/21.
//

import SwiftUI

struct CycleProgressView: View {
    let cycleLength: Int
    let cycleDay: Int?
    var body: some View {
        ZStack {
            if cycleDay == nil {
                Text("??/\(cycleLength)").font(.largeTitle)
            } else {
                ProgressArc(progress: min(Double(cycleDay!) / Double(cycleLength), 1))
                Text("\(cycleDay!)/\(cycleLength)").font(.largeTitle)
            }
        }
    }
}

struct ProgressArc : Shape {
    
    let progress: Double
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        p.addArc(center: CGPoint(x: rect.midX, y:rect.midY), radius: min(rect.height, rect.width) / 2, startAngle: .degrees(-90), endAngle: .degrees(-90 - 360 * progress), clockwise: true)
        
        return p.strokedPath(StrokeStyle(lineWidth: 5))
    }
}

struct CycleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CycleProgressView(cycleLength: 31, cycleDay: 25)
        CycleProgressView(cycleLength: 31, cycleDay: 31)
        CycleProgressView(cycleLength: 31, cycleDay: 34)
    }
}
