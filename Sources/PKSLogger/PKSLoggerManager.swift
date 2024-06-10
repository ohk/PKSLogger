//
//  PKSLoggerManager.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/4/24.
//

import Foundation
import OSLog
import Combine


public class PKSLoggerManager: ObservableObject {
    /// System wide logger configuration.
    @Published var loggerGlobalConfiguration: LoggerConfiguration
    
    /// A dictionary that holds all loggers.
    private var loggers: [String: PKSLogger] = [:]
    
    /// A shared instance of `UserDefaultsManager`.
    private var userDefaultsManager: UserDefaultsManager = .init()
    
    /// A set that holds all cancellables.
    private var cancellables: Set<AnyCancellable> = []
    
    /// Logger Manager System Logger
    private var systemLogger: PKSLogger
    
    /// Initialize the `PKSLoggerManager`.
    ///
    /// This function will initialize the `PKSLoggerManager` with the global logger configuration.
    /// - Returns: Void
    ///
    private init() {
        let systemConfiguration = userDefaultsManager.loadGlobalLoggerSettings()
        self.loggerGlobalConfiguration = systemConfiguration
        self.systemLogger = PKSLogger(systemConfiguration)
        // System initialization log
        systemLogger.info("PKSLogger | MANAGER | Log Manager Initialized")
        trackGlobalConfigurationChanges()
    }
    
    /// Track global configuration changes.
    ///
    /// This function will track the global configuration changes and save them to the `UserDefaults`.
    /// - Returns: Void
    ///
    private func trackGlobalConfigurationChanges() {
        $loggerGlobalConfiguration
            .sink { [weak self] newConfiguration in
                self?.systemLogger.hideLogs = newConfiguration.hideLogs
                self?.systemLogger.storeLogs = newConfiguration.storeLogs
                self?.systemLogger.logLevel = OSLogType(rawValue: newConfiguration.logLevel)

                self?.userDefaultsManager.saveGlobalLoggerSettings(newConfiguration)
                self?.systemLogger.info("PKSLogger | MANAGER | New Global Configuration detected. Changes saved to UserDefaults. Changes will be applied to all loggers.")
            }
            .store(in: &cancellables)
            systemLogger.info("PKSLogger | MANAGER | Global Configuration Changes started to track")
    }
    
    /// This function will be returned PKSLogger object based on subsystem and category.
    ///
    /// This function will try to get the logger from the dictionary. If the logger is not found, it will create a new logger with the given subsystem and category.
    /// ```swift
    /// let logger = PKSLoggerManager.shared.getLogger(subsystem: "com.example", category: "example")
    /// logger.debug("Hello, World!")
    /// ```
    /// - Parameters:
    ///   - subsystem: A string value that indicates the subsystem.
    ///   - category: A string value that indicates the category.
    /// - Returns: A `PKSLogger` object.
    public func getLogger(subsystem: String, category: String) -> PKSLogger {
        let key = "\(subsystem)-\(category)"
        if let logger = loggers[key] {
            systemLogger.info("PKSLogger | MANAGER | Logger found in the dictionary. Returning the existing logger.")
            return logger
        } else {
            systemLogger.info("PKSLogger | MANAGER | Logger not found in the dictionary. Creating a new logger.")
            let configuration = getLoggerConfiguration(subsystem: subsystem, category: category)
            let logger = PKSLogger(configuration)
            loggers[key] = logger
            return logger
        }
    }
    
    /// Get logger configuration based on subsystem and category.
    ///
    /// This function will try to load the logger settings from the `UserDefaults` with the key `PKSLoggerConfiguration-\(subsystem)-\(category)`.
    /// If the logger settings are not found, this function will return the default logger configuration.
    /// Default logger configuration is based on the global logger configuration.
    /// - Parameters:
    ///  - subsystem: A string value that indicates the subsystem.
    ///  - category: A string value that indicates the category.
    /// - Returns: A `LoggerConfiguration` object that holds the logger settings.
    ///
    private func getLoggerConfiguration(subsystem: String, category: String) -> LoggerConfiguration {
        if let configuration = userDefaultsManager.loadLoggerSettings(subsystem: subsystem, category: category) {
            systemLogger.info("PKSLogger | MANAGER | Logger Configuration found in UserDefaults. Returning the existing configuration.")
            return configuration
        } else {
            systemLogger.info("PKSLogger | MANAGER | Logger Configuration not found in UserDefaults. Returning the default configuration.")
            return LoggerConfiguration(
                storeLogs: loggerGlobalConfiguration.storeLogs,
                logLevel: loggerGlobalConfiguration.logLevel,
                hideLogs: loggerGlobalConfiguration.hideLogs,
                subsystem: subsystem,
                category: category
            )
        }
    }
}
