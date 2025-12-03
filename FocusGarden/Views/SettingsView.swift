//
//
//  SettingsView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI
import UniformTypeIdentifiers
import CloudKit

struct SettingsView: View {
    @Binding var settings: TimerSettings
    @Binding var language: AppLanguage
    @Binding var theme: AppTheme
    @Binding var iCloudSyncEnabled: Bool
    let getProgress: () -> Progress
    let onImportProgress: (Progress) -> Void
    let onClose: () -> Void

    @Environment(\.presentationMode) var presentationMode
    @State private var isExporting = false
    @State private var isImporting = false
    @State private var exportDocument = ProgressDocument(progress: Progress.empty)
    @State private var importError: String?
    @State private var iCloudAccountStatus: CKAccountStatus = .couldNotDetermine

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundLight.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Language Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.focusGreen)
                                Text("settings_language")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            Picker(NSLocalizedString("settings_language_picker", comment: "Language picker"), selection: $language) {
                                ForEach(AppLanguage.allCases, id: \.self) { language in
                                    Text(language.displayName).tag(language)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .padding(20)
                        .cardStyle()

                        // iCloud Sync Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "icloud")
                                    .foregroundColor(.focusGreen)
                                Text("settings_icloud")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            Toggle(isOn: $iCloudSyncEnabled) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("settings_icloud_toggle")
                                        .font(.system(size: 15))
                                        .foregroundColor(.textPrimary)

                                    Text("settings_icloud_subtitle")
                                        .font(.system(size: 12))
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .focusGreen))

                            HStack(spacing: 8) {
                                Circle()
                                    .fill(iCloudStatusColor)
                                    .frame(width: 10, height: 10)

                                Text(iCloudStatusText)
                                    .font(.system(size: 12))
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .padding(20)
                        .cardStyle()

                        // Theme Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "moon.fill")
                                    .foregroundColor(.focusGreen)
                                Text("settings_theme")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            Toggle(isOn: Binding(
                                get: { theme == .dark },
                                set: { theme = $0 ? .dark : .system }
                            )) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("settings_theme_toggle")
                                        .font(.system(size: 15))
                                        .foregroundColor(.textPrimary)

                                    Text("settings_theme_subtitle")
                                        .font(.system(size: 12))
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .focusGreen))
                        }
                        .padding(20)
                        .cardStyle()

                        // Timer Duration Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.focusGreen)
                                Text("settings_timer_duration")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            // Focus Time
                            TimerSlider(
                                title: NSLocalizedString("focus_time", comment: "Focus time slider title"),
                                value: $settings.focusTime,
                                range: 5...60,
                                step: 5,
                                color: .focusGreen,
                                unit: NSLocalizedString("minutes_unit", comment: "Minutes unit label")
                            )

                            // Short Break
                            TimerSlider(
                                title: NSLocalizedString("short_break", comment: "Short break slider title"),
                                value: $settings.breakTime,
                                range: 1...15,
                                step: 1,
                                color: .breakBlue,
                                unit: NSLocalizedString("minutes_unit", comment: "Minutes unit label")
                            )

                            // Long Break
                            TimerSlider(
                                title: NSLocalizedString("long_break", comment: "Long break slider title"),
                                value: $settings.longBreakTime,
                                range: 5...30,
                                step: 5,
                                color: .longBreakPurple,
                                unit: NSLocalizedString("minutes_unit", comment: "Minutes unit label")
                            )
                        }
                        .padding(20)
                        .cardStyle()

                        // Sound Settings Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: settings.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                    .foregroundColor(.focusGreen)
                                Text("settings_sound")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            Toggle(isOn: $settings.soundEnabled) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("settings_completion_sound")
                                        .font(.system(size: 15))
                                        .foregroundColor(.textPrimary)

                                    Text("settings_completion_sound_subtitle")
                                        .font(.system(size: 12))
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .focusGreen))
                        }
                        .padding(20)
                        .cardStyle()

                        // Info Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("💡")
                                    .font(.system(size: 20))
                                Text("settings_pomodoro_title")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            Text("settings_pomodoro_description")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.grassGreen.opacity(0.5),
                                    Color.skyBlue.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)

                        // Export / Import Section (bottom)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "square.and.arrow.up.on.square")
                                    .foregroundColor(.focusGreen)
                                Text("settings_backup_title")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            VStack(spacing: 12) {
                                Button {
                                    exportDocument = ProgressDocument(progress: getProgress())
                                    isExporting = true
                                } label: {
                                    HStack {
                                        Image(systemName: "arrow.up.doc.fill")
                                        Text("settings_export")
                                    }
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.backgroundCard.opacity(0.9))
                                    .cornerRadius(12)
                                }

                                Button {
                                    isImporting = true
                                } label: {
                                    HStack {
                                        Image(systemName: "arrow.down.doc.fill")
                                        Text("settings_import")
                                    }
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.backgroundCard.opacity(0.9))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(20)
                        .cardStyle()
                    }
                    .padding(20)
                }
            }
            .navigationTitle(Text("settings_title"))
            .navigationBarTitleDisplayMode(.large)
            .tint(.focusGreenDark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("done_button", comment: "Done button")) {
                        presentationMode.wrappedValue.dismiss()
                        onClose()
                    }
                    .foregroundColor(.focusGreenDark)
                    .fontWeight(.bold)
                }
            }
            .fileExporter(
                isPresented: $isExporting,
                document: exportDocument,
                contentType: .json,
                defaultFilename: "FocusGardenProgress"
            ) { result in
                if case .failure(let error) = result {
                    importError = error.localizedDescription
                }
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.json]
            ) { result in
                switch result {
                case .success(let url):
                    do {
                        let data = try Data(contentsOf: url)
                        let imported = try JSONDecoder().decode(Progress.self, from: data)
                        onImportProgress(imported)
                    } catch {
                        importError = NSLocalizedString("settings_import_error", comment: "Import error message")
                    }
                case .failure:
                    importError = NSLocalizedString("settings_import_error", comment: "Import error message")
                }
            }
            .alert(isPresented: Binding(
                get: { importError != nil },
                set: { _ in importError = nil }
            )) {
                Alert(
                    title: Text(NSLocalizedString("settings_import_error_title", comment: "Import error title")),
                    message: Text(importError ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                fetchICloudStatus()
            }
        }
    }
}

struct TimerSlider: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    let color: Color
    let unit: String

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)

                Spacer()

                Text("\(value) \(unit)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }

            Slider(
                value: Binding(
                    get: { Double(value) },
                    set: { value = Int($0) }
                ),
                in: Double(range.lowerBound)...Double(range.upperBound),
                step: Double(step)
            )
            .accentColor(color)
        }
    }
}

#Preview {
    SettingsView(
        settings: .constant(.default),
        language: .constant(.english),
        theme: .constant(.system),
        iCloudSyncEnabled: .constant(true),
        getProgress: { .empty },
        onImportProgress: { _ in },
        onClose: {}
    )
}

// MARK: - iCloud helpers

private extension SettingsView {
    func fetchICloudStatus() {
        // Avoid crashing if app lacks CloudKit entitlements: rely on ubiquity token presence
        if FileManager.default.ubiquityIdentityToken != nil {
            iCloudAccountStatus = .available
        } else {
            iCloudAccountStatus = .noAccount
        }
    }

    var iCloudStatusText: String {
        switch iCloudAccountStatus {
        case .available:
            return iCloudSyncEnabled
                ? NSLocalizedString("settings_icloud_status_on", comment: "iCloud on")
                : NSLocalizedString("settings_icloud_status_off", comment: "iCloud off")
        case .noAccount:
            return NSLocalizedString("settings_icloud_status_no_account", comment: "No iCloud account")
        case .restricted:
            return NSLocalizedString("settings_icloud_status_restricted", comment: "iCloud restricted")
        case .temporarilyUnavailable:
            return NSLocalizedString("settings_icloud_status_unavailable", comment: "iCloud temporarily unavailable")
        default:
            return NSLocalizedString("settings_icloud_status_checking", comment: "Checking iCloud status")
        }
    }

    var iCloudStatusColor: Color {
        switch iCloudAccountStatus {
        case .available:
            return iCloudSyncEnabled ? .focusGreen : .textSecondary
        case .noAccount, .restricted, .temporarilyUnavailable:
            return .red
        case .couldNotDetermine:
            return .textSecondary
        @unknown default:
            return .textSecondary
        }
    }
}

// MARK: - File document helper

@MainActor
struct ProgressDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }

    var progress: Progress

    init(progress: Progress) {
        self.progress = progress
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.progress = try JSONDecoder().decode(Progress.self, from: data)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(progress)
        return .init(regularFileWithContents: data)
    }
}
