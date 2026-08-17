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
        VStack {
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
            
            Button {
                do {
                    Task {
                        try await workoutViewModel.requestAuthorization()
                    }
                    try workoutViewModel.startWorkout()
                } catch {
                    print("Erro: \(error.localizedDescription)")
                }
            } label: {
                Text("Começar treino")
            }
            
            Button {
                do {
                    try workoutViewModel.endWorkout()
                } catch {
                    print("Erro: \(error.localizedDescription)")
                }
            } label: {
                Text("Finalizar treino")
            }
        }.task {
            do {
                try await workoutViewModel.requestAuthorization()
            } catch {
                print("Erro: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    WorkoutContentView()
}
