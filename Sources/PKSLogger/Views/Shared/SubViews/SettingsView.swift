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
///   - content: Content of the section
/// - Returns: SettingsView
struct SettingsView<Content : View>: View {
    /// Name of the section
    var sectionName: String
    
    /// Button to show the content details
    let content: Content

    /// Logger instance
    @StateObject var logger: PKSLogger
    
    /// Initialize the view with a section name, a logger and a content
    /// 
    /// - Parameters:
    ///  - sectionName: Name of the section
    ///  - logger: Logger instance
    ///   - contentBuilder: Content of the section
    /// - Returns: SettingsView
    /// 
    init(sectionName: String, logger: PKSLogger, @ViewBuilder contentBuilder: () -> Content) {
        self.content = contentBuilder()
        self.sectionName = sectionName
        self._logger = StateObject(wrappedValue: logger)
    }

    /// Initialize the view with a section name and a logger
    /// 
    /// - Parameters:
    ///   - sectionName: Name of the section
    ///   - logger: Logger instance
    /// - Returns: SettingsView
    /// 
    init(sectionName: String, logger: PKSLogger) where Content == EmptyView {
        self.content = EmptyView()
        self.sectionName = sectionName
        self._logger = StateObject(wrappedValue: logger)
    }

    /// Body of the SettingsView
    var body: some View {
        Section {
            LogLevelPicker(logLevel: $logger.logLevel)
            StoreLogsToggleView(storeLog: $logger.storeLogs)
            HideLogsToggleView(hideLogs: $logger.hideLogs)
        } header: {
            HStack {
                Text(sectionName)
                Spacer()
                content
            }
        }

    }
}

#Preview {
    SettingsView(sectionName: "TEST", logger: PKSLogger(.defaultGlobalConfiguration))
}
