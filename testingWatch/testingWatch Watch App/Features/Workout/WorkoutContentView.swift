//
//  WorkoutContent.swift
//  testingWatch Watch App
//
//  Created by Paulo Henrique Costa Alves on 13/08/26.
//

import SwiftUI
import WorkoutKit

struct WorkoutContentView: View {
    
    private var workoutViewModel: WorkoutViewModel = WorkoutViewModel()
    
    var body: some View {
        Button {
            Task {
                do {
                    try await workoutViewModel.plan?.openInWorkoutApp()
                } catch {
                    print("Deu erro: \(error.localizedDescription)")
                }
            }
        } label: {
            Text("Visualizar treino")
        }
        
        Button {
            workoutViewModel.createWorkout()
        } label: {
            Text("Criar treino")
        }
    }
}

#Preview {
    WorkoutContentView()
}
