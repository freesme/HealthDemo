//
//  OtherContentViews.swift
//  HealthDemo
//
//  Created by K K on 2025/6/22.
//

import SwiftUI
import HealthKit

// MARK: - 欢迎页面
struct WelcomeView: View {
    let healthKitAvailable: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
            
            Text("欢迎使用 HealthKit Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("从侧边栏选择一个功能开始探索 HealthKit 的各种能力")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if healthKitAvailable {
                Text("✅ HealthKit 已准备就绪")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("⚠️ 请在真机上运行以使用 HealthKit")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
        }
        .padding()
    }
}

// MARK: - HealthKit不可用提示
struct HealthKitUnavailableView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("HealthKit 不可用")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("HealthKit 需要在真实的iOS设备上运行。请在真机上测试此功能。")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - 概览内容
struct OverviewContent: View {
    let healthKitAvailable: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if !healthKitAvailable {
                HealthKitUnavailableView()
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("HealthKit 功能概览")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("HealthKit 是苹果提供的健康数据框架，允许应用安全地访问和共享健康相关信息。")
                        .font(.body)
                    
                    Button("开始探索") {
                        // Add code to use HealthKit here.
                        print("开始探索 HealthKit 功能")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
        }
    }
}

// MARK: - 健康数据内容
struct HealthDataContent: View {
    let healthKitAvailable: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if !healthKitAvailable {
                HealthKitUnavailableView()
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                    
                    Text("健康数据读取功能")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("即将推出：读取和显示各种健康数据类型")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - 运动数据内容
struct WorkoutsContent: View {
    let healthKitAvailable: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if !healthKitAvailable {
                HealthKitUnavailableView()
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("运动数据功能")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("即将推出：运动和锻炼数据管理")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - 心率内容
struct HeartRateContent: View {
    let healthKitAvailable: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if !healthKitAvailable {
                HealthKitUnavailableView()
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                    
                    Text("心率监测功能")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("即将推出：心率数据监测和分析")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - 步数内容
struct StepsContent: View {
    let healthKitAvailable: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if !healthKitAvailable {
                HealthKitUnavailableView()
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    
                    Text("步数统计功能")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("即将推出：步数和活动数据")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - 权限内容
struct PermissionsContent: View {
    let healthKitAvailable: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if !healthKitAvailable {
                HealthKitUnavailableView()
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    Text("权限管理功能")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("即将推出：健康数据访问权限")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - 样本数据内容
struct SamplesContent: View {
    let healthKitAvailable: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if !healthKitAvailable {
                HealthKitUnavailableView()
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.purple)
                    
                    Text("样本数据功能")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("即将推出：创建和管理样本数据")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
} 
