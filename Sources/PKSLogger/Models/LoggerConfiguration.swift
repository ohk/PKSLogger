//
//  LoggerConfiguration.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/6/24.
//

import OSLog

struct LoggerConfiguration: Codable {
    /// A boolean value that indicates whether logs should be stored or not.
    var storeLogs: Bool
    /// An integer value that indicates the log level.
    var logLevel: UInt8
    /// A boolean value that indicates whether logs should be hidden or not.
    var hideLogs: Bool
    /// A string value that indicates the subsystem.
    var subsystem: String
    /// A string value that indicates the category.
    var category: String
}

// MARK: - LoggerConfiguration Computed Properties Extension
extension LoggerConfiguration {
    /// A string value that indicates the key for the `LoggerConfiguration`.
    var key: String {
        return "\(subsystem)-\(category)"
    }
}

// MARK: - LoggerConfiguration Initializers Extension
extension LoggerConfiguration {
    /// Initializes a new `LoggerConfiguration` object.
    /// - Parameters:
    ///   - storeLogs: A boolean value that indicates whether logs should be stored or not.
    ///   - logLevel: An integer value that indicates the log level.
    ///   - hideLogs: A boolean value that indicates whether logs should be hidden or not.
    /// - Returns: A new `LoggerConfiguration` object.
    init(
        storeLogs: Bool,
        logLevel: OSLogType,
        hideLogs: Bool,
        subsystem: String,
        category: String
    ) {
        self.storeLogs = storeLogs
        self.logLevel = logLevel.rawValue
        self.hideLogs = hideLogs
        self.subsystem = subsystem
        self.category = category
    }
}

extension LoggerConfiguration {
    /// Initializes a new `LoggerConfiguration` object.
    ///
    ///
    /// - Parameters:
    ///  - storeLogs: A boolean value that indicates whether logs should be stored or not.
    ///  - logLevel: An integer value that indicates the log level.
    ///  - hideLogs: A boolean value that indicates whether logs should be hidden or not.
    ///  - subsystem: A string value that indicates the subsystem.
    ///  - category: A string value that indicates the category.
    ///  - Returns: A new `LoggerConfiguration` object.
    ///
    static func defaultConfiguration(subsystem: String, category: String, logLevel: OSLogType) -> LoggerConfiguration {
        switch logLevel {
        case .default, .info, .debug, .error, .fault:
            return LoggerConfiguration(
                storeLogs: true,
                logLevel: logLevel,
                hideLogs: false,
                subsystem: subsystem,
                category: category
            )
        case .production:
            return LoggerConfiguration(
                storeLogs: false,
                logLevel: .production,
                hideLogs: true,
                subsystem: subsystem,
                category: category
            )
        default:
            return LoggerConfiguration(
                storeLogs: false,
                logLevel: .default,
                hideLogs: true,
                subsystem: subsystem,
                category: category
            )
        }
    }

    /// Static property that returns the default global configuration.
    ///
    /// - Returns: A new `LoggerConfiguration` object.
    ///
    static var defaultGlobalConfiguration: LoggerConfiguration {
        return LoggerConfiguration(
            storeLogs: true,
            logLevel: .debug,
            hideLogs: false,
            subsystem: "com.poikus.foundation.logger",
            category: "GLOBAL"
        )
    }
}
