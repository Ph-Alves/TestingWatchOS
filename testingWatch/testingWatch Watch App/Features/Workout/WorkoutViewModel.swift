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
final class WorkoutViewModel {
    
    var plan: WorkoutPlan?
    
    func createWorkout() {
        let workout = SingleGoalWorkout(activity: .boxing)
        plan = WorkoutPlan(.goal(workout))
    }
}
