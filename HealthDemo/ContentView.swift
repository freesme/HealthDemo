//
//  ContentView.swift
//  HealthDemo
//
//  Created by K K on 2025/6/22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var selectedPage: DemoPage? = .availability
    @State private var healthKitAvailable = false
    @State private var healthStore = HKHealthStore()
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // 侧边栏
            SidebarView(selectedPage: $selectedPage, healthKitAvailable: healthKitAvailable)
        } detail: {
            // 详情页面
            DetailView(page: selectedPage, healthKitAvailable: healthKitAvailable, healthStore: healthStore)
        }
        .onAppear {
            checkHealthKitAvailability()
        }
    }
    
    private func checkHealthKitAvailability() {
        if HKHealthStore.isHealthDataAvailable() {
            healthKitAvailable = true
            // Add code to use HealthKit here.
            print("HealthKit 检查：设备支持HealthKit")
        } else {
            healthKitAvailable = false
            print("HealthKit 检查：设备不支持HealthKit")
        }
    }
}

#Preview {
    ContentView()
}
