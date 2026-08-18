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

// MARK: - View Model de workout
// Observable para manter a view atualizada
@Observable
// Precisa conformar com NSObject para ser usado como Delegate/DataSource
final class WorkoutViewModel: NSObject {
    // MARK: - Variables
    
    // HealthStore para fazer processos de saúde
    private let healthStore = HKHealthStore()
    // Sessão para começar um workout
    private var session: HKWorkoutSession?
    // Builder para coletar amostras de workout
    private var builder: HKLiveWorkoutBuilder?
    // Flag para definir que o workout ta rodando
    private var isRunning = false
    // Planejamento de treino
    var plan: WorkoutPlan?
    
    // MARK: - Functions
    // Função de criar workout
    // Cria um workout de arquearia de objetivo simples
    // depois estabelece o plano com o objetivo do workout.
    func createWorkout() {
        let workout = SingleGoalWorkout(activity: .archery)
        self.plan = WorkoutPlan(.goal(workout))
    }
    
    // Função de solicitar autorização
    // Define os dados a serem escritos e os dados a serem lidos
    // são sets (dados únicos) que definem objetos HK
    // Usamos quantity type pois são tipos que guardam um valor numérico
    // e dentro deles pegamos os dados de batimento, energia gasta etc...
    func requestAuthorization() async throws {
        let typesToShare: Set = [ HKQuantityType.workoutType() ]
        let typesToRead: Set<HKObjectType> = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.basalEnergyBurned)
        ]
        
        // Solicita permissão de uso no healthStore.
        try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
    }
    
    // Função de começar workout
    // define uma config, session e builder, começando a atividade e a coleta de amostras.
    func startWorkout() throws {
        // A config determina o tipo de treino e onde é (dentro ou fora de casa)
        let config = HKWorkoutConfiguration()
        config.activityType = .coreTraining
        config.locationType = .indoor
        
        // Prepara a session que vai ser executada (exercício)
        session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
        // Pega o builder associado
        builder = session?.associatedWorkoutBuilder()
        
        // Define os delegates e prepara o data source
        session?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)
        
        // Começa a atividade no date atual e a coleta de amostras.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate, completion: {_,_ in })
        
        // ativa a flag de execução.
        isRunning = true
    }
    
    // Função de finalizar o workout
    // para os dados serem atualizados, o workout precisa ser finalizado, nesse caso específico
    // não temos tempo e ele deve ser finalizado manualmente.
    func endWorkout() throws {
        // Finaliza a sessão
        session?.end()
        // Volta a flag
        isRunning = false
        
        // Finaliza a coleta de dados (não precisamos de parâmetros, por isso _ e [weak self]
        builder?.endCollection(withEnd: Date()) { [weak self] _, _ in
            self?.builder?.finishWorkout() { _,_ in }
        }
    }
}

// MARK: - Extensions
// Para a view model conformar com os protocolos delegate
extension WorkoutViewModel: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: any Error) {
    }
}

extension WorkoutViewModel: HKLiveWorkoutBuilderDelegate {
    // Aproveitamos o coletor de amostra para printar o bpm e calorias de uma maneira formatada
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
