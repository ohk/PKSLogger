//
//  LoggerDetailView.swift
//
//
//  Created by Ömer Hamid Kamışlı on 6/9/24.
//

import SwiftUI

struct LoggerDetailView: View {
    @State var logger: PKSLogger
    
    var body: some View {
        List {
            SettingsView(sectionName: "Settings", logger: logger)
            
            Section("Logs") {
                ForEach(logger.logs, id: \.self) { log in
                    Text(log)
                }
            }

        }
    }
}

#Preview {
    let logger = PKSLogger(.defaultGlobalConfiguration)
    logger.logLevel = .default
    logger.info("Test 1")
    logger.info("Test 2")
    logger.info("Test 3")
    logger.info("Test 4")
    logger.warning("Test 5")
    logger.fault("Test 6")
    return LoggerDetailView(logger: logger)
}
