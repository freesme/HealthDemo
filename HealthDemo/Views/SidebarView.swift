//
//  SidebarView.swift
//  HealthDemo
//
//  Created by K K on 2025/6/22.
//

import SwiftUI

// MARK: - 侧边栏视图
struct SidebarView: View {
    @Binding var selectedPage: DemoPage?
    let healthKitAvailable: Bool
    
    var body: some View {
        List(DemoPage.allCases, selection: $selectedPage) { page in
            NavigationLink(value: page) {
                HStack {
                    Image(systemName: page.icon)
                        .foregroundColor(.accentColor)
                        .frame(width: 25)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(page.rawValue)
                            .font(.headline)
                        Text(page.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .navigationTitle("HealthKit Demo")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    if healthKitAvailable {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                    }
                    
                    Text(healthKitAvailable ? "可用" : "不可用")
                        .font(.caption)
                        .foregroundColor(healthKitAvailable ? .green : .orange)
                }
            }
        }
    }
} 