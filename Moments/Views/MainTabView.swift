import SwiftUI

struct MainTabView: View {
    @StateObject private var localizationService = LocalizationService.shared
    @State private var languageRefresh = UUID()
    
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today".localized, systemImage: "sun.max.fill")
                }
            
            CatalogView()
                .tabItem {
                    Label("Catalog".localized, systemImage: "square.grid.2x2.fill")
                }
            
            AddMomentView()
                .tabItem {
                    Label("Add".localized, systemImage: "plus.circle.fill")
                }
            
            StatisticsView()
                .tabItem {
                    Label("Statistics".localized, systemImage: "chart.bar.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile".localized, systemImage: "person.fill")
                }
        }
        .accentColor(.primary)
        .onReceive(NotificationCenter.default.publisher(for: .languageChanged)) { _ in
            languageRefresh = UUID()
        }
        .id(languageRefresh)
    }
}
