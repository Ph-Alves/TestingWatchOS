//
//  ContentView.swift
//  testingWatch Watch App
//
//  Created by Paulo Henrique Costa Alves on 12/08/26.
//

import SwiftUI
import HealthKit

// MARK: - View
struct HealthContentView: View {
    
    // MARK: - Variables
    
    // ViewModel
    let healthViewModel: HealthViewModel = HealthViewModel()
    
    // Dados para visualização (pode passar para VM se quiser)
    @State private var bloodType: HKBloodType?
    @State private var dateOfBirth: Date?
    @State private var biologicalSex: HKBiologicalSex?
    @State private var wheelChairUse: HKWheelchairUse?
    
    // MARK: - Body View
    var body: some View {
        // Se dados existem mostra todos, se não reabra o app.
        VStack {
            if let bloodType, let dateOfBirth, let biologicalSex, let wheelChairUse {
                Text("\(bloodType.displayName)")
                Text("\(dateOfBirth.formatted())")
                Text("\(biologicalSex.displayName)")
                Text("\(wheelChairUse.displayName)")
            } else {
                Text("Sem dados! (Reabra o app)")
            }
        }
        .padding()
        .task {
            // Faz todos os gets da viewModel (o load pede permissão)
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

// MARK: - Extensions
// Todos as extensions servem para mostrar um valor formatado baseando-se no caso do enum, fiz com IA para acelerar o processo, mas garanto que ta revisado.

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

// MARK: - Preview
#Preview {
    HealthContentView()
}
