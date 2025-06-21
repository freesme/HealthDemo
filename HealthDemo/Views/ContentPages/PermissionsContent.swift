//
//  PermissionsContent.swift
//  HealthDemo
//
//  Created by K K on 2025/6/22.
//

import SwiftUI
import HealthKit

// MARK: - HealthKit数据类型定义
struct HealthDataType: Identifiable {
    let id = UUID()
    let name: String
    let type: HKSampleType
    let category: String
    let icon: String
    let description: String
    let isWriteSupported: Bool
    
    static let allTypes: [HealthDataType] = [
        // 身体测量
        HealthDataType(name: "身高", type: HKQuantityType(.height), category: "身体测量", icon: "ruler.fill", description: "身高数据", isWriteSupported: true),
        HealthDataType(name: "体重", type: HKQuantityType(.bodyMass), category: "身体测量", icon: "scalemass.fill", description: "体重数据", isWriteSupported: true),
        HealthDataType(name: "体脂百分比", type: HKQuantityType(.bodyFatPercentage), category: "身体测量", icon: "percent", description: "体脂率", isWriteSupported: true),
        HealthDataType(name: "BMI", type: HKQuantityType(.bodyMassIndex), category: "身体测量", icon: "figure.stand", description: "身体质量指数", isWriteSupported: true),
        
        // 生命体征
        HealthDataType(name: "心率", type: HKQuantityType(.heartRate), category: "生命体征", icon: "heart.fill", description: "心率数据", isWriteSupported: true),
        HealthDataType(name: "血压(收缩压)", type: HKQuantityType(.bloodPressureSystolic), category: "生命体征", icon: "drop.fill", description: "收缩压", isWriteSupported: true),
        HealthDataType(name: "血压(舒张压)", type: HKQuantityType(.bloodPressureDiastolic), category: "生命体征", icon: "drop.fill", description: "舒张压", isWriteSupported: true),
        HealthDataType(name: "体温", type: HKQuantityType(.bodyTemperature), category: "生命体征", icon: "thermometer", description: "体温数据", isWriteSupported: true),
        HealthDataType(name: "血氧饱和度", type: HKQuantityType(.oxygenSaturation), category: "生命体征", icon: "lungs.fill", description: "血氧水平", isWriteSupported: true),
        
        // 活动数据
        HealthDataType(name: "步数", type: HKQuantityType(.stepCount), category: "活动数据", icon: "figure.walk", description: "每日步数", isWriteSupported: true),
        HealthDataType(name: "距离", type: HKQuantityType(.distanceWalkingRunning), category: "活动数据", icon: "location.fill", description: "行走跑步距离", isWriteSupported: true),
        HealthDataType(name: "活跃能量", type: HKQuantityType(.activeEnergyBurned), category: "活动数据", icon: "flame.fill", description: "活动消耗卡路里", isWriteSupported: true),
        HealthDataType(name: "基础能量", type: HKQuantityType(.basalEnergyBurned), category: "活动数据", icon: "gauge.medium", description: "基础代谢", isWriteSupported: true),
        HealthDataType(name: "爬楼层数", type: HKQuantityType(.flightsClimbed), category: "活动数据", icon: "figure.stairs", description: "爬楼数据", isWriteSupported: true),
        
        // 睡眠数据
        HealthDataType(name: "睡眠分析", type: HKCategoryType(.sleepAnalysis), category: "睡眠数据", icon: "bed.double.fill", description: "睡眠时间和质量", isWriteSupported: true),
        
        // 营养数据
        HealthDataType(name: "膳食能量", type: HKQuantityType(.dietaryEnergyConsumed), category: "营养数据", icon: "fork.knife", description: "摄入卡路里", isWriteSupported: true),
        HealthDataType(name: "水分摄入", type: HKQuantityType(.dietaryWater), category: "营养数据", icon: "drop.triangle.fill", description: "饮水量", isWriteSupported: true),
        
        // 女性健康
        HealthDataType(name: "月经", type: HKCategoryType(.menstrualFlow), category: "女性健康", icon: "heart.circle.fill", description: "月经周期", isWriteSupported: true),
        
        // 其他
        HealthDataType(name: "听音量", type: HKQuantityType(.headphoneAudioExposure), category: "听力健康", icon: "headphones", description: "耳机音量暴露", isWriteSupported: false)
    ]
}

// MARK: - 权限状态管理
@MainActor
class PermissionsManager: ObservableObject {
    @Published var permissionStates: [UUID: HKAuthorizationStatus] = [:]
    @Published var loadingStates: [UUID: Bool] = [:]
    @Published var lastUpdateTime: Date?
    @Published var showingSettings = false
    
    private let healthStore = HKHealthStore()
    
    func checkAllPermissions() {
        // 首先检查HealthKit是否可用
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit不可用")
            return
        }
        
        Task {
            var newStates: [UUID: HKAuthorizationStatus] = [:]
            
            for dataType in HealthDataType.allTypes {
                let status = healthStore.authorizationStatus(for: dataType.type)
                newStates[dataType.id] = status
            }
            
            await MainActor.run {
                self.permissionStates = newStates
                self.lastUpdateTime = Date()
            }
        }
    }
    
    func requestPermission(for dataType: HealthDataType) async {
        // 检查HealthKit是否可用
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit不可用，无法请求权限")
            return
        }
        
        await MainActor.run {
            loadingStates[dataType.id] = true
        }
        
        let readTypes: Set<HKSampleType> = [dataType.type]
        let writeTypes: Set<HKSampleType> = dataType.isWriteSupported ? [dataType.type] : []
        
        do {
            try await healthStore.requestAuthorization(toShare: writeTypes, read: readTypes)
            
            await MainActor.run {
                let newStatus = healthStore.authorizationStatus(for: dataType.type)
                permissionStates[dataType.id] = newStatus
                loadingStates[dataType.id] = false
                lastUpdateTime = Date()
                print("权限请求成功: \(dataType.name) - \(newStatus)")
            }
        } catch {
            print("权限请求失败: \(dataType.name) - \(error.localizedDescription)")
            if let healthKitError = error as? HKError {
                switch healthKitError.code {
                case .errorHealthDataUnavailable:
                    print("健康数据不可用")
                default:
                    print("HealthKit错误代码: \(healthKitError.code.rawValue)")
                }
            }
            await MainActor.run {
                loadingStates[dataType.id] = false
            }
        }
    }
    
    func openHealthSettings() {
        showingSettings = true
    }
}

// MARK: - 权限内容页面
struct PermissionsContent: View {
    let healthKitAvailable: Bool
    @StateObject private var permissionsManager = PermissionsManager()
    @State private var selectedCategory: String = "全部"
    @State private var searchText = ""
    
    private var categories: [String] {
        let allCategories = HealthDataType.allTypes.map { $0.category }
        return ["全部"] + Array(Set(allCategories)).sorted()
    }
    
    private var filteredDataTypes: [HealthDataType] {
        var types = HealthDataType.allTypes
        
        // 分类筛选
        if selectedCategory != "全部" {
            types = types.filter { $0.category == selectedCategory }
        }
        
        // 搜索筛选
        if !searchText.isEmpty {
            types = types.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return types
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !healthKitAvailable {
                HealthKitUnavailableView()
                    .padding()
            } else {
                // 顶部信息区域
                headerSection
                
                // 搜索和筛选区域
                searchAndFilterSection
                
                // 权限列表
                permissionsList
            }
        }
        .onAppear {
            if healthKitAvailable {
                permissionsManager.checkAllPermissions()
            }
        }
        .alert("前往健康设置", isPresented: $permissionsManager.showingSettings) {
            Button("前往设置") {
                if let settingsUrl = URL(string: "x-apple-health://") {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("取消", role: .cancel) { }
        } message: {
            Text("要撤销权限，请在系统设置的'健康'应用中管理权限。")
        }
    }
    
    // MARK: - 头部区域
    private var headerSection: some View {
        VStack(spacing: 16) {
            // 标题区域
            VStack(spacing: 12) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.accentColor)
                
                Text("HealthKit 权限管理")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("为每个健康数据类型单独管理访问权限")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // 统计信息
            HStack(spacing: 20) {
                StatCard(
                    title: "总计",
                    count: HealthDataType.allTypes.count,
                    color: .blue
                )
                
                StatCard(
                    title: "已授权",
                    count: authorizedCount,
                    color: .green
                )
                
                StatCard(
                    title: "已拒绝",
                    count: deniedCount,
                    color: .red
                )
                
                StatCard(
                    title: "未确定",
                    count: notDeterminedCount,
                    color: .orange
                )
            }
            
            // 操作按钮
            HStack(spacing: 12) {
                Button("刷新状态") {
                    permissionsManager.checkAllPermissions()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Button("健康设置") {
                    permissionsManager.openHealthSettings()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                if let lastUpdate = permissionsManager.lastUpdateTime {
                    Text("更新: \(lastUpdate, style: .time)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - 搜索和筛选区域
    private var searchAndFilterSection: some View {
        VStack(spacing: 12) {
            // 搜索框
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("搜索健康数据类型...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button("清除") {
                        searchText = ""
                    }
                    .font(.caption)
                    .foregroundColor(.accentColor)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // 分类选择器
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { category in
                        CategoryChip(
                            title: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - 权限列表
    private var permissionsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredDataTypes) { dataType in
                    PermissionCard(
                        dataType: dataType,
                        status: permissionsManager.permissionStates[dataType.id] ?? .notDetermined,
                        isLoading: permissionsManager.loadingStates[dataType.id] ?? false,
                        onRequestPermission: {
                            Task {
                                await permissionsManager.requestPermission(for: dataType)
                            }
                        },
                        onOpenSettings: {
                            permissionsManager.openHealthSettings()
                        }
                    )
                }
                
                if filteredDataTypes.isEmpty {
                    EmptyStateView(searchText: searchText)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - 计算属性
    private var authorizedCount: Int {
        permissionsManager.permissionStates.values.filter { $0 == .sharingAuthorized }.count
    }
    
    private var deniedCount: Int {
        permissionsManager.permissionStates.values.filter { $0 == .sharingDenied }.count
    }
    
    private var notDeterminedCount: Int {
        permissionsManager.permissionStates.values.filter { $0 == .notDetermined }.count
    }
}

// MARK: - 统计卡片
struct StatCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 60)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - 分类芯片
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

// MARK: - 权限卡片
struct PermissionCard: View {
    let dataType: HealthDataType
    let status: HKAuthorizationStatus
    let isLoading: Bool
    let onRequestPermission: () -> Void
    let onOpenSettings: () -> Void
    
    private var statusColor: Color {
        switch status {
        case .sharingAuthorized: return .green
        case .sharingDenied: return .red
        case .notDetermined: return .orange
        @unknown default: return .gray
        }
    }
    
    private var statusText: String {
        switch status {
        case .sharingAuthorized: return "已授权"
        case .sharingDenied: return "已拒绝"
        case .notDetermined: return "未确定"
        @unknown default: return "未知"
        }
    }
    
    private var statusIcon: String {
        switch status {
        case .sharingAuthorized: return "checkmark.circle.fill"
        case .sharingDenied: return "xmark.circle.fill"
        case .notDetermined: return "questionmark.circle.fill"
        @unknown default: return "minus.circle.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // 图标
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: dataType.icon)
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
            
            // 信息区域
            VStack(alignment: .leading, spacing: 4) {
                Text(dataType.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(dataType.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    // 分类标签
                    Text(dataType.category)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray6))
                        .cornerRadius(4)
                    
                    // 写入支持标签
                    if dataType.isWriteSupported {
                        Text("可写入")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
            
            // 状态和操作区域
            VStack(alignment: .trailing, spacing: 8) {
                // 权限状态
                HStack(spacing: 4) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: statusIcon)
                            .foregroundColor(statusColor)
                    }
                    
                    Text(statusText)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(statusColor)
                }
                
                // 操作按钮
                if !isLoading {
                    HStack(spacing: 6) {
                        // 请求权限按钮
                        if status == .notDetermined {
                            Button("请求权限") {
                                onRequestPermission()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.mini)
                        } else if status == .sharingAuthorized {
                            Button("重新请求") {
                                onRequestPermission()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.mini)
                        } else if status == .sharingDenied {
                            Button("重新请求") {
                                onRequestPermission()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.mini)
                        }
                        
                        // 设置按钮
                        if status != .notDetermined {
                            Button("管理") {
                                onOpenSettings()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.mini)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - 空状态视图
struct EmptyStateView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text(searchText.isEmpty ? "没有权限数据" : "未找到匹配的权限")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if !searchText.isEmpty {
                Text("尝试搜索其他关键词")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
} 
