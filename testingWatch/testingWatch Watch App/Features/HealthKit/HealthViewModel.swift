//
//  ViewModel.swift
//  testingWatch Watch App
//
//  Created by Paulo Henrique Costa Alves on 13/08/26.
//

import Foundation
import SwiftUI
import HealthKit

enum error: Error {
    case cannotGetDateOfBirth
}

@Observable
final class HealthViewModel {
    
    private var healthStore: HKHealthStore
    
    init() {
        self.healthStore = HKHealthStore()
    }
    
    func loadHealthData() async throws {
        let typesToRead: Set<HKObjectType> = [
            HKCharacteristicType(.bloodType),
            HKCharacteristicType(.dateOfBirth),
            HKCharacteristicType(.biologicalSex),
            HKCharacteristicType(.wheelchairUse)
        ]
        
        print("Pedindo autorização...") // adicione isso
        try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
        print("Autorização concluída") // e isso
    }
    
    func getBloodType() throws -> HKBloodType {
        return try healthStore.bloodType().bloodType
    }
    
    func getDateOfBirth() throws -> Date {
        let date = try healthStore.dateOfBirthComponents()
        let calendar = Calendar.current
        if let finalDate = calendar.date(from: date) {
            return finalDate
        } else {
            throw error.cannotGetDateOfBirth
        }
    }
    
    func getBiologicalSex() throws -> HKBiologicalSex {
        return try healthStore.biologicalSex().biologicalSex
    }
    
    func getWeelchairUse() throws -> HKWheelchairUse {
        return try healthStore.wheelchairUse().wheelchairUse
    }
}
