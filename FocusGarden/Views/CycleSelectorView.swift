//
//  CycleSelectorView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct CycleSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCycles: Int = 10
    let onStart: (Int) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text(NSLocalizedString("cycle_selector_title", comment: "Select cycles title"))
                    .font(.title2)
                    .fontWeight(.bold)

                // Large display of selected cycles
                VStack(spacing: 10) {
                    Text("\(selectedCycles)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.accentColor)

                    Text(NSLocalizedString("cycles_label", comment: "Cycles"))
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 20)

                // Stepper for precise cycle selection
                Stepper(value: $selectedCycles, in: 1...90, step: 1) {
                    Text("\(selectedCycles) \(NSLocalizedString(\"cycles_label\", comment: \"Cycles label\"))")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                // Start button
                Button {
                    onStart(selectedCycles)
                    dismiss()
                } label: {
                    Text(NSLocalizedString("workout_start", comment: "Start workout"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.exerciseOrange, Color.exerciseOrangeDark],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    CycleSelectorView { cycles in
        print("Selected \(cycles) cycles")
    }
}
