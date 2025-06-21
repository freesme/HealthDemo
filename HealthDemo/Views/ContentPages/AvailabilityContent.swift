//
//  AvailabilityContent.swift
//  HealthDemo
//
//  Created by K K on 2025/6/22.
//

import SwiftUI
import HealthKit

// MARK: - HealthKit可用性检测内容
struct AvailabilityContent: View {
    let healthKitAvailable: Bool
    @State private var deviceInfo: String = ""
    @State private var systemVersion: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // 检测结果卡片
            VStack(spacing: 16) {
                if healthKitAvailable {
                    // HealthKit可用
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("✅ HealthKit 可用")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        Text("当前设备支持HealthKit功能，您可以使用所有健康数据相关的功能。")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    // HealthKit不可用
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        
                        Text("⚠️ HealthKit 不可用")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        
                        Text("HealthKit需要在真实的iOS设备上运行。iOS模拟器不支持HealthKit功能。")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // 设备信息卡片
            VStack(alignment: .leading, spacing: 12) {
                Text("设备信息")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(title: "设备型号", value: deviceInfo)
                    InfoRow(title: "系统版本", value: systemVersion)
                    InfoRow(title: "HealthKit状态", value: healthKitAvailable ? "可用" : "不可用")
                    InfoRow(title: "运行环境", value: isSimulator() ? "iOS模拟器" : "真实设备")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            // 检测按钮
            Button("重新检测") {
                performHealthKitCheck()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            // 说明信息
            VStack(alignment: .leading, spacing: 8) {
                Text("关于HealthKit可用性")
                    .font(.headline)
                
                Text("• HealthKit仅在真实的iOS设备上可用")
                Text("• iOS模拟器不支持HealthKit功能")
                Text("• 需要iOS 8.0或更高版本")
                Text("• 某些地区可能有限制")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.caption)
            .foregroundColor(.secondary)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .onAppear {
            loadDeviceInfo()
        }
    }
    
    private func loadDeviceInfo() {
        deviceInfo = UIDevice.current.model
        systemVersion = UIDevice.current.systemVersion
    }
    
    private func performHealthKitCheck() {
        // Add code to use HealthKit here.
        if HKHealthStore.isHealthDataAvailable() {
            print("HealthKit检测：可用")
        } else {
            print("HealthKit检测：不可用")
        }
    }
    
    private func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}

// MARK: - 信息行组件
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
} 