//
//  LoggerSettingsView.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/5/24.
//

import SwiftUI
import OSLog

public struct PKSLoggerSettingsView: View {
    /// LoggerManager instance
    @ObservedObject var loggerManager: PKSLoggerManager
    
    /// Global log level
    @State var globalLogLevel: OSLogType = .production

    /// Global store logs
    @State var globalStoreLogs: Bool = false

    /// Global hide logs
    @State var globalHideLogs: Bool = false
    
    /// Initialize the view with a logger manager
    ///
    /// This view is used to configure the loggers and the global settings. It is possible to change the log level, store logs and hide logs for each logger and the global settings.
    /// When the global settings are changed, the changes are reflected to all the loggers.
    /// > Important: There is a chance that the changes are not reflected to the all loggers. Please make sure to check the loggers after changing the global settings.
    /// - Parameter loggerManager: LoggerManager instance
    /// - Returns: PKSLoggerSettingsView
    /// 
    public init(loggerManager: PKSLoggerManager) {
        self.loggerManager = loggerManager
        self._globalLogLevel = State(initialValue: OSLogType(rawValue: loggerManager.loggerGlobalConfiguration.logLevel))
        self._globalHideLogs = State(initialValue: loggerManager.loggerGlobalConfiguration.hideLogs)
        self._globalStoreLogs = State(initialValue: loggerManager.loggerGlobalConfiguration.storeLogs)
    }
    
    /// Body of the LoggerSettingsView
    public var body: some View {
        List {
            Section {
                LogLevelPicker(logLevel: $globalLogLevel)
                StoreLogsToggleView(storeLog: $globalStoreLogs)
                HideLogsToggleView(hideLogs: $globalHideLogs)
            } header: {
                Text("Global Settings")
                    .font(.headline)
            }

            
            ForEach(loggerManager.availableLoggers) { logger in
                SettingsView(sectionName: logger.id, logger: logger)
            }
        }
        .onChange(of: globalLogLevel) { newValue in
            loggerManager.setGlobalLogLevel(newValue)
        }
        .onChange(of: globalStoreLogs) { newValue in
            loggerManager.setGlobalStoreLogs(newValue)
        }
        .onChange(of: globalHideLogs) { newValue in
            loggerManager.setGlobalHideLogs(newValue)
        }
    }
}

#Preview {
    let manager = PKSLoggerManager()
    let _ = manager.getLogger(subsystem: "a", category: "b")
    let _ = manager.getLogger(subsystem: "ab", category: "b")
    let _ = manager.getLogger(subsystem: "abc", category: "b")
    return PKSLoggerSettingsView(loggerManager: manager)
}
