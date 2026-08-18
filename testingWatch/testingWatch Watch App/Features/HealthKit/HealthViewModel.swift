//
//  ViewModel.swift
//  testingWatch Watch App
//
//  Created by Paulo Henrique Costa Alves on 13/08/26.
//

import Foundation
import SwiftUI
import HealthKit

// MARK: - Enum de erros personalizados
// Isso foi mais um teste para poder lançar erros personalizados
enum error: Error {
    case cannotGetDateOfBirth
}

// MARK: - View Model de saúde
// Observable para manter a view atualizada com modificações da VM
@Observable
final class HealthViewModel {
    
    // MARK: - Variables
    
    // HealthStore instanciado (para operações do HK)
    private var healthStore: HKHealthStore = HKHealthStore()
    
    // MARK: - Functions
    
    // Carrega os dados e pede autorização
    // nesse caso pede os dados apenas para leitura.
    func loadHealthData() async throws {
        let typesToRead: Set<HKObjectType> = [
            HKCharacteristicType(.bloodType),
            HKCharacteristicType(.dateOfBirth),
            HKCharacteristicType(.biologicalSex),
            HKCharacteristicType(.wheelchairUse)
        ]
        
        try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
    }
    
    // Pega o tipo sanguíneo do usuário
    func getBloodType() throws -> HKBloodType {
        return try healthStore.bloodType().bloodType
    }
    
    // Pega a data de nascimento do usuário
    func getDateOfBirth() throws -> Date {
        let date = try healthStore.dateOfBirthComponents()
        let calendar = Calendar.current
        if let finalDate = calendar.date(from: date) {
            return finalDate
        } else {
            throw error.cannotGetDateOfBirth
        }
    }
    
    // Pega o sexo biológico do usuário
    func getBiologicalSex() throws -> HKBiologicalSex {
        return try healthStore.biologicalSex().biologicalSex
    }
    
    // Pega se o usuário usa ou não cadeira de rodas
    func getWeelchairUse() throws -> HKWheelchairUse {
        return try healthStore.wheelchairUse().wheelchairUse
    }
}
