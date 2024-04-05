//
//  HealthManager.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 3/4/24.
//

import Foundation
import HealthKit

extension Date{
    static var startOfDay: Date{
        Calendar.current.startOfDay(for: Date())
    }
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }

class HealthManager: ObservableObject {
    
    let healthScore = HKHealthStore()
    
    
    @Published var activities: [String : Activity] = [:]
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let healthTypes: Set = [steps, calories]
        
        Task{
            do{
                try await healthScore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
            } catch{
                print("Error fetching health data")
            }
        }
    }
    
    func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in guard let quantity = result?.sumQuantity(), error == nil else {
            print("Error fetching todays step data")
            return
        }
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today Steps", subtitle: "Goal 10,000", image: "figure.walk", amount: stepCount.formattedString())
            DispatchQueue.main.async {
                self.activities["todaysSteps"] = activity
            }
        }
        
        healthScore.execute(query)
    }
    
    func fetchTodayCalories(){
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in guard let quantity = result?.sumQuantity(), error == nil else {
            print("Error fetching todays calory data")
            return
        }
            
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Today calories", subtitle: "Goal 900", image: "flame", amount: caloriesBurned.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todaysCalories"] = activity
            }
        }
        
        healthScore.execute(query)
    }
}


}


