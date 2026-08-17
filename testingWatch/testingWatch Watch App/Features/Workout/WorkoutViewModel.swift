//
//  WorkoutViewModel.swift
//  testingWatch Watch App
//
//  Created by Paulo Henrique Costa Alves on 13/08/26.
//

import Foundation
import SwiftUI
import WorkoutKit
import HealthKit

@Observable
final class WorkoutViewModel: NSObject {
    
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    var plan: WorkoutPlan?
    
    var isRunning = false
    
    func createWorkout() {
        let workout = SingleGoalWorkout(activity: .archery)
        self.plan = WorkoutPlan(.goal(workout))
    }
    
    func requestAuthorization() async throws {
        let typesToShare: Set = [ HKQuantityType.workoutType() ]
        let typesToRead: Set<HKObjectType> = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.basalEnergyBurned)
        ]
        
        try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
    }
    
    func startWorkout() throws {
        let config = HKWorkoutConfiguration()
        config.activityType = .coreTraining
        config.locationType = .indoor
        
        session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
        builder = session?.associatedWorkoutBuilder()
        
        session?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)
        
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate, completion: {_,_ in })
        
        isRunning = true
    }
    
    func endWorkout() throws {
        session?.end()
        isRunning = false
        
        builder?.endCollection(withEnd: Date()) { [weak self] _, _ in
            self?.builder?.finishWorkout() { _,_ in }
        }
    }
}

extension WorkoutViewModel: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: any Error) {
    }
}

extension WorkoutViewModel: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        if let hrStats = workoutBuilder.statistics(for: HKQuantityType(.heartRate)) {
            let bpm = hrStats.mostRecentQuantity()?.doubleValue(for: .count().unitDivided(by: .minute())) ?? 0
            print("Heart rate: \(bpm) bpm")
        }

        if let calStats = workoutBuilder.statistics(for: HKQuantityType(.activeEnergyBurned)) {
            let kcal = calStats.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            print("Calorias: \(kcal) kcal")
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
}
