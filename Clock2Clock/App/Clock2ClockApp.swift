//
//  Clock2ClockApp.swift
//  Clock2Clock
//
//  Created by Macbook  on 27/08/2023.
//

import SwiftUI
import Firebase

@main
struct Clock2ClockApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var errorModel = ErrorHandlingModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(errorModel)
        }
    }
}
