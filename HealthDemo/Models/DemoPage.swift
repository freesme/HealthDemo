//
//  DemoPage.swift
//  HealthDemo
//
//  Created by K K on 2025/6/22.
//

import Foundation

// MARK: - Demo页面类型定义
enum DemoPage: String, CaseIterable, Identifiable {
    case availability = "设备兼容性检测"
    case overview = "总览"
    case healthData = "健康数据读取"
    case workouts = "运动数据"
    case heartRate = "心率监测"
    case steps = "步数统计"
    case permissions = "权限管理"
    case samples = "样本数据"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .availability: return "checkmark.shield.fill"
        case .overview: return "house.fill"
        case .healthData: return "heart.text.square.fill"
        case .workouts: return "figure.run"
        case .heartRate: return "heart.fill"
        case .steps: return "figure.walk"
        case .permissions: return "lock.shield.fill"
        case .samples: return "doc.text.fill"
        }
    }
    
    var description: String {
        switch self {
        case .availability: return "检测HealthKit在设备上的可用性"
        case .overview: return "HealthKit功能概览"
        case .healthData: return "读取和显示健康数据"
        case .workouts: return "运动和锻炼数据管理"
        case .heartRate: return "心率数据监测和分析"
        case .steps: return "步数和活动数据"
        case .permissions: return "健康数据访问权限"
        case .samples: return "创建和管理样本数据"
        }
    }
} 