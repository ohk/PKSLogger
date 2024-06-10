//
//  HideLogsToggleView.swift
//  PKSLogger
//
//  Created by Ömer Hamid Kamışlı on 6/7/24.
//

import SwiftUI
/// A component to toggle the hide logs setting
/// 
/// This component takes a binding to a boolean value and toggles the value when the toggle is changed.
/// - Parameter hideLogs: Binding to a boolean value
/// - Returns: HideLogsToggleView
struct HideLogsToggleView: View {
    /// Binding to a boolean value
    @Binding var hideLogs: Bool
    
    /// Initialize the view with a binding to a boolean value
    init(hideLogs: Binding<Bool>) {
        self._hideLogs = hideLogs
    }
    
    /// Body of the HideLogsToggleView
    var body: some View {
        Toggle("Hide Logs", systemImage: "eye.slash.fill", isOn: $hideLogs)
    }
}

#Preview {
    HideLogsToggleView(hideLogs: .constant(true))
}
