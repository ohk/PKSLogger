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

    /// Logs an informational message.
    ///
    /// The `info` method logs a message at the `info` level if the current log level is set equal to or higher than `info`.
    /// This method is typically used for general informational messages that highlight the progress of the application.
    ///
    /// - Example:
    /// ```swift
    /// let logger = PKSLogger(subsystem: "com.poikus.app", category: "network")
    /// logger.info("Network request started")
    /// ```
    ///
    /// - Important: This method is not thread-safe. Stored logs are appended on a background queue. Stored logs order is not guaranteed.
    /// - Warning: This method is not safe for privacy and security. If you want to log sensitive data, please be careful. If you set wrong log level, it can be printed to the console or stored in the logs.
    /// - Parameter message: The message to log.
    public func info(_ message: String) {
        guard logLevel.rawValue <= OSLogType.info.rawValue else { return }
        
        if storeLogs {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.logs.append(message)
            }
        }
        
        if !hideLogs {
            logger.info("\(message)")
        }
    }
}