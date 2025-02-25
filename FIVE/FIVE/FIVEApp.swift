//
//  FIVEApp.swift
//  FIVE
//
//  Created by Jianmiao Cai on 2/24/25.
//

import SwiftUI

@main
struct FIVEApp: App {
    init() {
        // Set default value
        if UserDefaults.standard.object(forKey: "fetchLimit") == nil {
            UserDefaults.standard.set(10, forKey: "fetchLimit")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
