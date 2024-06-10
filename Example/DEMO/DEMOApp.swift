//
//  DEMOApp.swift
//  DEMO
//
//  Created by Ömer Hamid Kamışlı on 6/9/24.
//

import SwiftUI
import PKSLogger

@main
struct DEMOApp: App {
    @State var manager = PKSLoggerManager()
    
    init() {
        let aLogger = manager.getLogger(subsystem: "a", category: "b")
        _ = manager.getLogger(subsystem: "ab", category: "b")
        _ = manager.getLogger(subsystem: "abc", category: "b")
        for _ in stride(from: 0, to: 100, by: 1) {
            aLogger.info(String.random())
        }
    }
    
    var body: some Scene {
        WindowGroup {
            PKSLoggerSettingsView(loggerManager: manager)
        }
    }
}


extension String {

    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
