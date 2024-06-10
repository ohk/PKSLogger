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
    }
    
}
