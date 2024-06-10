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
