//
//  DetailView.swift
//  HealthDemo
//
//  Created by K K on 2025/6/22.
//

import SwiftUI
import HealthKit

// MARK: - 详情页面视图
struct DetailView: View {
    let page: DemoPage?
    let healthKitAvailable: Bool
    let healthStore: HKHealthStore
    
    var body: some View {
        Group {
            if let page = page {
                ScrollView {
                    VStack(spacing: 20) {
                        // 页面头部
                        VStack(spacing: 12) {
                            Image(systemName: page.icon)
                                .font(.system(size: 60))
                                .foregroundColor(.accentColor)
                            
                            Text(page.rawValue)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text(page.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        Divider()
                        
                        // 功能内容区域
                        VStack(spacing: 16) {
                            switch page {
                            case .availability:
                                AvailabilityContent(healthKitAvailable: healthKitAvailable)
                            case .overview:
                                OverviewContent(healthKitAvailable: healthKitAvailable)
                            case .healthData:
                                HealthDataContent(healthKitAvailable: healthKitAvailable)
                            case .workouts:
                                WorkoutsContent(healthKitAvailable: healthKitAvailable)
                            case .heartRate:
                                HeartRateContent(healthKitAvailable: healthKitAvailable)
                            case .steps:
                                StepsContent(healthKitAvailable: healthKitAvailable)
                            case .permissions:
                                PermissionsContent(healthKitAvailable: healthKitAvailable)
                            case .samples:
                                SamplesContent(healthKitAvailable: healthKitAvailable)
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal)
                }
            } else {
                // 默认欢迎页面
                WelcomeView(healthKitAvailable: healthKitAvailable)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
} 