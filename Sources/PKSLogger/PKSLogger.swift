//
//  PKSLogger.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/5/24.
//

import OSLog

public class PKSLogger: ObservableObject, Identifiable {
    /// The unique identifier of the logger.
    public var id: String
    
    /// A published property to store log messages.
    @Published var logs: [String] = []
    
    /// A published property indicating whether to store logs.
    @Published var storeLogs: Bool = false
    
    /// The current log level of the logger.
    @Published var logLevel: OSLogType
    
    /// A published property indicating whether to hide logs.
    @Published var hideLogs: Bool = false
    
    /// The logger instance.
    private var logger: Logger

    /// Initializes a new logger with the specified subsystem, category, and log level.
    /// - Parameters:
    ///   - configuration: The configuration of the logger. More details can be found in the ``LoggerConfiguration`` struct.
    /// - Returns: A new logger instance.
    init(_ configuration: LoggerConfiguration) {
        self.id = configuration.key
        self.logger = Logger(subsystem: configuration.subsystem, category: configuration.category)
        self.logLevel = OSLogType(rawValue: configuration.logLevel)
        self.storeLogs = configuration.storeLogs
        self.hideLogs = configuration.hideLogs
    }
}