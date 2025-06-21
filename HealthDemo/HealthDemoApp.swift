//
//  HealthDemoApp.swift
//  HealthDemo
//
//  Created by K K on 2025/6/22.
//

import SwiftUI
import HealthKit

@main
struct HealthDemoApp: App {
    
    init() {
        // 检查HealthKit在设备上是否可用
        if HKHealthStore.isHealthDataAvailable() {
            print("HealthKit 在此设备上可用")
            // Add code to use HealthKit here.
        } else {
            print("HealthKit 在此设备上不可用")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
