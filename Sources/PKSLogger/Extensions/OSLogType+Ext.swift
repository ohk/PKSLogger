//
//  OSLogType+Ext.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/5/24.
//

import OSLog

public extension OSLogType {
    /// A custom log level for production environments.
    static let production: OSLogType = .init(UInt8.max)
}
