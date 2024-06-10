//
//  StoreLogsToggleView.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/7/24.
//

import SwiftUI

/// A component to toggle the store logs setting
/// 
/// This component takes a binding to a boolean value and toggles the value when the toggle is changed.
/// - Parameter storeLog: Binding to a boolean value
/// - Returns: StoreLogsToggleView
/// 
struct StoreLogsToggleView: View {
    /// Binding to a boolean value
    @Binding var storeLog: Bool

    /// Initialize the view with a binding to a boolean value
    /// 
    /// - Parameter storeLog: Binding to a boolean value
    /// - Returns: StoreLogsToggleView
    init(storeLog: Binding<Bool>) {
        self._storeLog = storeLog
    }
    
    /// Initialize the view with a binding to a boolean value
    var body: some View {
        Toggle("Store Logs", systemImage: "externaldrive.fill.badge.plus", isOn: $storeLog)
    }
}

#Preview {
    StoreLogsToggleView(storeLog: .constant(true))
}
