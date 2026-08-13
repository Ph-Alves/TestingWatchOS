//
//  ContentView.swift
//  testingWatch Watch App
//
//  Created by Paulo Henrique Costa Alves on 12/08/26.
//

import SwiftUI
import HealthKit

struct HealthContentView: View {
    
    let healthViewModel: HealthViewModel = HealthViewModel()
    @State private var bloodType: HKBloodType?
    @State private var dateOfBirth: Date?
    @State private var biologicalSex: HKBiologicalSex?
    @State private var wheelChairUse: HKWheelchairUse?
    
    var body: some View {
        VStack {
            if let bloodType, let dateOfBirth, let biologicalSex, let wheelChairUse {
                Text("\(bloodType.displayName)")
                Text("\(dateOfBirth.formatted())")
                Text("\(biologicalSex.displayName)")
                Text("\(wheelChairUse.displayName)")
            } else {
                Text("Sem dados!")
            }
        }
        .padding()
        .task {
            do {
                try await healthViewModel.loadHealthData()
                bloodType = try healthViewModel.getBloodType()
                dateOfBirth = try healthViewModel.getDateOfBirth()
                biologicalSex = try healthViewModel.getBiologicalSex()
                wheelChairUse = try healthViewModel.getWeelchairUse()
            } catch {
                print("erro: \(error.localizedDescription)")
            }
        }
    }
}

extension HKBloodType {
    var displayName: String {
        switch self {
        case .notSet:    return "Não informado"
        case .aPositive: return "A+"
        case .aNegative: return "A-"
        case .bPositive: return "B+"
        case .bNegative: return "B-"
        case .abPositive: return "AB+"
        case .abNegative: return "AB-"
        case .oPositive: return "O+"
        case .oNegative: return "O-"
        @unknown default: return "Desconhecido"
        }
    }
}

extension HKBiologicalSex {
    var displayName: String {
        switch self {
        case .notSet:  return "Não informado"
        case .female:  return "Feminino"
        case .male:    return "Masculino"
        case .other:   return "Outro"
        @unknown default: return "Desconhecido"
        }
    }
}

extension HKWheelchairUse {
    var displayName: String {
        switch self {
        case .notSet: return "Não informado"
        case .no:     return "Não"
        case .yes:    return "Sim"
        @unknown default: return "Desconhecido"
        }
    }
}

#Preview {
    HealthContentView()
}
