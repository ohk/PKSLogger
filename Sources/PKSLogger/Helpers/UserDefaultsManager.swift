//
//  UserDefaultsManager.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/6/24.
//

import Foundation

class UserDefaultsManager {
    /// A function that saves the global logger settings.
    ///
    /// This function will try to encode the `LoggerConfiguration` object and save it to the `UserDefaults` with the key `PKSLoggerConfigurationGlobal`.
    /// - Parameter configuration: A `LoggerConfiguration` object that holds the global logger settings.
    /// - Returns: Void
    func saveGlobalLoggerSettings(_ configuration: LoggerConfiguration) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(configuration) {
            UserDefaults.standard.set(encoded, forKey: "PKSLoggerConfigurationGlobal")
        }
    }

    /// A function that loads the global logger settings.
    ///
    /// This function will try to decode the `LoggerConfiguration` object from the `UserDefaults` with the key `PKSLoggerConfigurationGlobal`.
    /// - Returns: A `LoggerConfiguration` object that holds the global logger settings.
    ///
    /// - Important: If the `UserDefaults` does not have the `PKSLoggerConfigurationGlobal` key, this function will return the default global configuration.
    func loadGlobalLoggerSettings() -> LoggerConfiguration {
        if let data = UserDefaults.standard.data(forKey: "PKSLoggerConfigurationGlobal") {
            let decoder = JSONDecoder()
            if let configuration = try? decoder.decode(LoggerConfiguration.self, from: data) {
                return configuration
            }
        }
        return LoggerConfiguration.defaultGlobalConfiguration
    }

    /// A function that saves the logger settings.
    ///
    /// This function will try to encode the `LoggerConfiguration` object and save it to the `UserDefaults` with the key `PKSLoggerConfiguration-\(configuration.key)`.
    /// - Parameter configuration: A `LoggerConfiguration` object that holds the logger settings.
    /// - Returns: Void
    func saveLoggerSettings(_ configuration: LoggerConfiguration) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(configuration) {
            UserDefaults.standard.set(encoded, forKey: "PKSLoggerConfiguration-\(configuration.key)")
        }
    }

    /// A function that loads the logger settings.
    ///
    /// This function will try to decode the `LoggerConfiguration` object from the `UserDefaults` with the key `PKSLoggerConfiguration-\(subsystem)-\(category)`.
    /// - Parameters:
    ///  - subsystem: A string value that indicates the subsystem.
    ///  - category: A string value that indicates the category.
    /// - Returns: A `LoggerConfiguration` object that holds the logger settings.
    ///
    func loadLoggerSettings( subsystem: String, category: String) -> LoggerConfiguration? {
        if let data = UserDefaults.standard.data(forKey: "PKSLoggerConfiguration-\(subsystem)-\(category)") {
            let decoder = JSONDecoder()
            if let configuration = try? decoder.decode(LoggerConfiguration.self, from: data) {
                return configuration
            }
        }
        return nil
    }
}

