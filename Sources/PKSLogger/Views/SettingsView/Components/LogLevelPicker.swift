//
//  LogLevelPicker.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/7/24.
//

import SwiftUI
import OSLog

/// A component to pick the log level
/// 
/// This component takes a binding to a OSLogType and picks the log level when the picker is changed.
/// - Parameter logLevel: Binding to a OSLogType
/// - Returns: LogLevelPicker
struct LogLevelPicker: View {
    /// Binding to a OSLogType
    @Binding var logLevel: OSLogType
    
    /// Log level enum
    @State private var logLevelEnum: LogLevel
    
    /// Initialize the view with a binding to a OSLogType
    /// 
    /// - Parameter logLevel: Binding to a OSLogType
    /// - Returns: LogLevelPicker
    init(logLevel: Binding<OSLogType>) {
        self._logLevel = logLevel
        self.logLevelEnum = LogLevel.from(logLevel: logLevel.wrappedValue)
    }

    /// Initialize the view with a binding to a OSLogType
    var body: some View {
        Picker("Log Level",systemImage: "lock.rectangle.stack.fill", selection: $logLevelEnum) {
            ForEach(LogLevel.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.menu)
        .onChange(of: logLevelEnum) { val in
            logLevel = val.getOSLogType
        }
        .onChange(of: logLevel) { newValue in
            logLevelEnum = LogLevel.from(logLevel: newValue)
        }
    }
}


#Preview {
    LogLevelPicker(logLevel: .constant(.production))
}
