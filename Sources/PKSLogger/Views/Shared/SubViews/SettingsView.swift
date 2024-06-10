//
//  SettingsView.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/7/24.
//

import SwiftUI

/// A component to configure the logger settings
/// 
/// This component takes a section name and a logger instance and configures the logger settings.
/// - Parameters:
///   - sectionName: Name of the section
///   - logger: Logger instance
/// - Returns: SettingsView
struct SettingsView: View {
    /// Name of the section
    var sectionName: String

    /// Logger instance
    @StateObject var logger: PKSLogger
    
    /// Initialize the view with a section name and a logger
    /// 
    /// - Parameters:
    ///  - sectionName: Name of the section
    ///  - logger: Logger instance
    init(sectionName: String, logger: PKSLogger) {
        self.sectionName = sectionName
        self._logger = StateObject(wrappedValue: logger)
    }

    /// Body of the SettingsView
    var body: some View {
        Section(sectionName) {
            LogLevelPicker(logLevel: $logger.logLevel)
            StoreLogsToggleView(storeLog: $logger.storeLogs)
            HideLogsToggleView(hideLogs: $logger.hideLogs)
        }
    }
}

#Preview {
    SettingsView(sectionName: "TEST", logger: PKSLogger(.defaultGlobalConfiguration))
}
