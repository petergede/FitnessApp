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
    
    static var startOfWeek: Date {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let startOfWeek = calendar.date(byAdding: .day, value: -weekday + 1, to: now)!
        return calendar.startOfDay(for: startOfWeek)
    }
    
    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let oneMonth = calendar.date(byAdding: .month, value: -1, to: Date())
        return calendar.startOfDay(for: oneMonth!)
    }
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

class HealthManager: ObservableObject {
    
    let healthScore = HKHealthStore()
    
    
    @Published var activities: [String : Activity] = [:]
    
    @Published var oneMonthChartData = [DailyStepView]()
    
    @Published var mockActivities: [String : Activity] = [
        "todaysSteps" : Activity(id: 0, title: "Today Steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: "12,123"),
        "todaysCalories" : Activity(id: 1, title: "Today calories", subtitle: "Goal 900", image: "flame",tintColor: .red, amount: "1,243")
    ]
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKQuantityType.workoutType()
        let healthTypes: Set = [steps, calories, workout]
        
        Task{
            do{
                try await healthScore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchCurrentWeekStats()
                fetchPastMonthStepData() 
            } catch{
                print("Error fetching health data")
            }
        }
    }
    
    func fetchDailySteps(startDate: Date, completion : @escaping ([DailyStepView]) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = {query, result , error in
            guard let result = result else {
                completion([])
                return
            }
            var dailySteps = [DailyStepView]()
            
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                dailySteps.append(DailyStepView(date: statistics.startDate, stepCount:
                                                    statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.00))
            }
            completion(dailySteps)
        }
        healthScore.execute(query)
    }
    
    func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in guard let quantity = result?.sumQuantity(), error == nil else {
            print("Error fetching todays step data")
            return
        }
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today Steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: stepCount.formattedString())
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
            let activity = Activity(id: 1, title: "Today calories", subtitle: "Goal 900", image: "flame",tintColor: .red, amount: caloriesBurned.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todaysCalories"] = activity
            }
        }
        
        healthScore.execute(query)
    }
    
    
    func fetchCurrentWeekStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: timePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("Error fetching weekly data")
                return
            }
            
            var runningCount: Int = 0
            var swimmingCount: Int = 0
            var cyclingCount: Int = 0
            for workout in workouts {
                if workout.workoutActivityType == .running{
                    let duration = Int(workout.duration)/60
                    runningCount += duration
                } else if workout.workoutActivityType == .swimming{
                    let duration = Int(workout.duration)/60
                    swimmingCount += duration
                } else if workout.workoutActivityType == .cycling{
                    let duration = Int(workout.duration)/60
                    cyclingCount += duration
                }
                
            }
            let runningActivity = Activity(id: 2, title: "Ruuning", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(runningCount) minutes")
            let swimmingActivity = Activity(id: 3, title: "Swimming", subtitle: "This week", image: "figure.pool.swim", tintColor: .blue, amount: "\(swimmingCount) minutes")
            let cyclingActivity = Activity(id: 4, title: "Cycling", subtitle: "This week", image: "figure.outdoor.cycle", tintColor: .indigo, amount: "\(cyclingCount) minutes")
            
            DispatchQueue.main.async {
                self.activities["weekRunning"] = runningActivity
                self.activities["weekSwimming"] = swimmingActivity
                self.activities["weekCycling"] = cyclingActivity
            }
        }
        healthScore.execute(query)
    }
}


//MARK: Chart Data
extension HealthManager {
    
    func fetchPastMonthStepData() {
        fetchDailySteps(startDate: .oneMonthAgo) { dailySteps in
            DispatchQueue.main.async {
                self.oneMonthChartData = dailySteps
            }
        }
    }
}




