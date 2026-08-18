//
//  WorkoutContent.swift
//  testingWatch Watch App
//
//  Created by Paulo Henrique Costa Alves on 13/08/26.
//

import SwiftUI
import WorkoutKit

// MARK: - View de Workout
struct WorkoutContentView: View {
    
    // MARK: - Variables
    private var workoutViewModel: WorkoutViewModel = WorkoutViewModel()
    
    // MARK: - Body View
    var body: some View {
        // A view possui 4 buttons, cada um responsável:
        // - Executa no workout o plano feito
        // - Criar um plano de workout
        // - Executar um workout e Pedir autorização de uso
        // - Finalizar um workout
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
        // Solicita permissão assim que a view é renderizada a primeira vez.
        }.task {
            do {
                try await workoutViewModel.requestAuthorization()
            } catch {
                print("Erro: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    WorkoutContentView()
}
