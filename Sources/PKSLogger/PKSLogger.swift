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
    
    /// Logs a debug message.
    ///
    /// The `debug` method logs a message at the `debug` level if the current log level is set equal to or higher than `debug`.
    /// This method is used for debugging information, which is typically of use only when diagnosing problems.
    ///
    /// - Example:
    /// ```swift
    /// let logger = PKSLogger(subsystem: "com.example.app", category: "network")
    /// logger.debug("Received response from server")
    /// ```
    ///
    /// - Important: This method is not thread-safe. Stored logs are appended on a background queue. Stored logs order is not guaranteed.
    /// - Warning: This method is not safe for privacy and security. If you want to log sensitive data, please be careful. If you set wrong log level, it can be printed to the console or stored in the logs.
    /// - Parameter message: The message to log.
    public func debug(_ message: String) {
        guard logLevel.rawValue <= OSLogType.debug.rawValue else { return }
        
        if storeLogs {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.logs.append(message)
            }
        }
        
        if !hideLogs {
            logger.debug("\(message)")
        }
    }
    
    /// Logs a notice message.
    ///
    /// The `notice` method logs a message at the `default` level if the current log level is set equal to or higher than `default`.
    /// This method is used for notices, which are messages that are less important than informational messages but still noteworthy.
    ///
    /// - Example:
    /// ```swift
    /// let logger = PKSLogger(subsystem: "com.example.app", category: "network")
    /// logger.notice("User logged in")
    /// ```
    ///
    /// - Important: This method is not thread-safe. Stored logs are appended on a background queue. Stored logs order is not guaranteed.
    /// - Warning: This method is not safe for privacy and security. If you want to log sensitive data, please be careful. If you set wrong log level, it can be printed to the console or stored in the logs.
    /// - Parameter message: The message to log.
    public func notice(_ message: String) {
        guard logLevel.rawValue <= OSLogType.default.rawValue else { return }
        
        if storeLogs {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.logs.append(message)
            }
        }
        
        if !hideLogs {
            logger.notice("\(message)")
        }
    }
    
    /// Logs a warning message.
    ///
    /// The `warning` method logs a message at the `error` level if the current log level is set equal to or higher than `error`.
    /// This method is used for warnings, which indicate potential problems or issues that should be noted.
    ///
    /// - Example:
    /// ```swift
    /// let logger = PKSLogger(subsystem: "com.example.app", category: "network")
    /// logger.warning("Slow network response time")
    /// ```
    ///
    /// - Important: This method is not thread-safe. Stored logs are appended on a background queue. Stored logs order is not guaranteed.
    /// - Warning: This method is not safe for privacy and security. If you want to log sensitive data, please be careful. If you set wrong log level, it can be printed to the console or stored in the logs.
    /// - Parameter message: The message to log.
    public func warning(_ message: String) {
        guard logLevel.rawValue <= OSLogType.error.rawValue else { return }
        
        if storeLogs {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.logs.append(message)
            }
        }
        
        logger.warning("\(message)")
    }
    
    /// Logs an error message.
    ///
    /// The `error` method logs a message at the `error` level if the current log level is set equal to or higher than `error`.
    /// This method is used for error messages, which indicate serious problems that need to be addressed.
    ///
    /// - Example:
    /// ```swift
    /// let logger = PKSLogger(subsystem: "com.example.app", category: "network")
    /// logger.error("Failed to connect to server")
    /// ```
    ///
    /// - Important: This method is not thread-safe. Stored logs are appended on a background queue. Stored logs order is not guaranteed.
    /// - Warning: This method is not safe for privacy and security. If you want to log sensitive data, please be careful. If you set wrong log level, it can be printed to the console or stored in the logs.
    /// - Parameter message: The message to log.
    public func error(_ message: String) {
        guard logLevel.rawValue <= OSLogType.error.rawValue else { return }
        
        if storeLogs {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.logs.append(message)
            }
        }
        
        if !hideLogs {
            logger.error("\(message)")
        }
    }
    
    /// Logs a critical message.
    ///
    /// The `critical` method logs a message at the `fault` level if the current log level is set equal to or higher than `fault`.
    /// This method is used for critical messages, which indicate severe problems that have caused or are about to cause major issues.
    ///
    /// - Example:
    /// ```swift
    /// let logger = PKSLogger(subsystem: "com.example.app", category: "network")
    /// logger.critical("Server crash detected")
    /// ```
    ///
    /// - Important: This method is not thread-safe. Stored logs are appended on a background queue. Stored logs order is not guaranteed.
    /// - Warning: This method is not safe for privacy and security. If you want to log sensitive data, please be careful. If you set wrong log level, it can be printed to the console or stored in the logs.
    /// - Parameter message: The message to log.
    public func critical(_ message: String) {
        guard logLevel.rawValue <= OSLogType.fault.rawValue else { return }
        
        if storeLogs {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.logs.append(message)
            }
        }
        
        if !hideLogs {
            logger.critical("\(message)")
        }
    }
    
    /// Logs a fault message.
    ///
    /// The `fault` method logs a message at the `fault` level if the current log level is set equal to or higher than `fault`.
    /// This method is used for fault messages, which indicate catastrophic failures that require immediate attention.
    ///
    /// - Example:
    /// ```swift
    /// let logger = PKSLogger(subsystem: "com.example.app", category: "network")
    /// logger.fault("Out of memory error")
    /// ```
    ///
    /// - Important: This method is not thread-safe. Stored logs are appended on a background queue. Stored logs order is not guaranteed.
    /// - Warning: This method is not safe for privacy and security. If you want to log sensitive data, please be careful. If you set wrong log level, it can be printed to the console or stored in the logs.
    /// - Parameter message: The message to log.
    public func fault(_ message: String) {
        guard logLevel.rawValue <= OSLogType.fault.rawValue else { return }
        
        if storeLogs {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.logs.append(message)
            }
        }
        
        logger.fault("\(message)")
    }
    
    /// Logs a message with a specified log level.
    ///
    /// The `log` method logs a message at the specified log level if the current log level is set equal to or higher than the specified log level.
    /// This method allows for logging messages with different levels of severity.
    ///
    /// - Example:
    /// ```swift
    /// let logger = PKSLogger(subsystem: "com.example.app", category: "network")
    /// logger.log("Custom log message", logLevel: .debug)
    /// ```
    ///
    /// - Important: This method is not thread-safe. Stored logs are appended on a background queue. Stored logs order is not guaranteed.
    /// - Warning: This method is not safe for privacy and security. If you want to log sensitive data, please be careful. If you set wrong log level, it can be printed to the console or stored in the logs.
    /// - Parameters:
    ///   - message: The message to log.
    ///   - logLevel: The log level to use.
    public func log(_ message: String, logLevel: OSLogType) {
        guard logLevel.rawValue <= logLevel.rawValue, logLevel != .production else { return }
        
        if storeLogs {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.logs.append(message)
            }
        }
        
        if !hideLogs {
            logger.log(level: logLevel, "\(message)")
        }
    }
    
    /// Returns the underlying logger instance.
    ///
    /// The `getLogger` method returns the underlying `Logger` instance used by this class.
    ///
    /// - Example:
    /// ```swift
    /// let logger = PKSLogger(subsystem: "com.example.app", category: "network")
    /// let underlyingLogger = logger.getLogger()
    /// ```
    ///
    /// - Returns: The `Logger` instance.
    /// - Warning: This method is returning the underlying logger instance. Be careful when using it. When you use the underlying logger instance, you are responsible for the logs. When you use the underlying logger instance, the logs are not stored or hidden. 
    /// - Tip: If you want to use the logger instance, please use the methods provided by this class.
    public func getLogger() -> Logger {
        return logger
    }
}
