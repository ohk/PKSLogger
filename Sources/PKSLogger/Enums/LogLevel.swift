//
//  LogLevel.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/7/24.
//

import Foundation
import OSLog

/// A type to represent the log level
enum LogLevel: String, Hashable, CaseIterable {
    case `default` = "Default"
    case info = "Info"
    case debug = "Debug"
    case error = "Error"
    case fault = "Fault"
    case production = "Production"
    
    /// Get the OSLogType from the log level
    var getOSLogType: OSLogType {
        switch self {
        case .default:
            return .default
        case .info:
            return .info
        case .debug:
            return .debug
        case .error:
            return .error
        case .fault:
            return .fault
        case .production:
            return .production
        }
    }
    
}


extension LogLevel {
    /// Get the log level from the OSLogType
    ///
    /// - Parameter logLevel: OSLogType
    /// - Returns: LogLevel
    ///
    static func from(logLevel: OSLogType) -> LogLevel {
        switch logLevel {
        case .default:
            return .debug
        case .info:
            return .info
        case .debug:
            return .debug
        case .error:
            return .error
        case .fault:
            return .fault
        case .production:
            return .production
        default:
            return .production
        }
    }
}
