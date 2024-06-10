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
            trackLoggerConfigurationChanges(logger, subsystem, category)
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
    
    /// Track logger configuration changes.
    ///
    /// This function will track the logger configuration changes and save them to the `UserDefaults`.
    /// - Parameters:
    ///  - logger: A `PKSLogger` object.
    ///  - subsystem: A string value that indicates the subsystem.
    ///  - category: A string value that indicates the category.
    private func trackLoggerConfigurationChanges(_ logger: PKSLogger,_ subsystem: String,_ category: String) {
        logger.$storeLogs
            .combineLatest(logger.$hideLogs, logger.$logLevel)
            .sink { [weak self] storeLogsConfiguration, hideLogsConfiguration, logLevelConfiguration in
                self?.userDefaultsManager.saveLoggerSettings(.init(storeLogs: storeLogsConfiguration, logLevel: logLevelConfiguration, hideLogs: hideLogsConfiguration, subsystem: subsystem, category: category))
                self?.systemLogger.info("PKSLogger | \(logger.id) | New Logger Configuration detected. Changes saved to UserDefaults.")
            }
            .store(in: &cancellables)
    }
    
    /// Set the global log level.
    ///
    /// This function will set the global log level and save it to the `UserDefaults`.
    /// - Parameter logLevel: An integer value that indicates the log level.
    /// - Returns: Void
    ///
    public func setGlobalLogLevel(_ logLevel: OSLogType) {
        systemLogger.info("PKSLogger | MANAGER | Global Log Level changed to \(logLevel).")
        let copy = LoggerConfiguration(
            storeLogs: loggerGlobalConfiguration.storeLogs,
            logLevel: logLevel,
            hideLogs: loggerGlobalConfiguration.hideLogs,
            subsystem: loggerGlobalConfiguration.subsystem,
            category: loggerGlobalConfiguration.category
        )
        loggerGlobalConfiguration = copy
    }

    /// Set the global store logs setting.
    ///
    /// This function will set the global store logs setting and save it to the `UserDefaults`.
    /// - Parameter storeLogs: A boolean value that indicates whether logs should be stored or not.
    /// - Returns: Void
    ///
    public func setGlobalStoreLogs(_ storeLogs: Bool) {
        systemLogger.info("PKSLogger | MANAGER | Global Store Logs setting changed to \(storeLogs ? "enabled" : "disabled").")
        let copy = LoggerConfiguration(
            storeLogs: storeLogs,
            logLevel: loggerGlobalConfiguration.logLevel,
            hideLogs: loggerGlobalConfiguration.hideLogs,
            subsystem: loggerGlobalConfiguration.subsystem,
            category: loggerGlobalConfiguration.category
        )
        loggerGlobalConfiguration = copy
    }

    /// Set the global hide logs setting.
    ///
    /// This function will set the global hide logs setting and save it to the `UserDefaults`.
    /// - Parameter hideLogs: A boolean value that indicates whether logs should be hidden or not.
    /// - Returns: Void
    ///
    public func setGlobalHideLogs(_ hideLogs: Bool) {
        systemLogger.info("PKSLogger | MANAGER | Global Hide Logs setting changed to \(hideLogs ? "enabled" : "disabled").")
        let copy = LoggerConfiguration(
            storeLogs: loggerGlobalConfiguration.storeLogs,
            logLevel: loggerGlobalConfiguration.logLevel,
            hideLogs: hideLogs,
            subsystem: loggerGlobalConfiguration.subsystem,
            category: loggerGlobalConfiguration.category
        )
        loggerGlobalConfiguration = copy
    }
}
