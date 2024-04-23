//
//  ChartsView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 5/4/24.
//

import SwiftUI
import Charts


struct DailyStepView: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount : Double
}

struct ChartsView: View {
    @EnvironmentObject var manager: HealthManager
    
    var body: some View {
        VStack{
            Chart{
                ForEach(manager.oneMonthChartData) { daily in
                    BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y:
                        .value("Steps", daily.stepCount))
                }
            }
        }
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View{
        ChartsView()
            .environmentObject(HealthManager())
    }
}
