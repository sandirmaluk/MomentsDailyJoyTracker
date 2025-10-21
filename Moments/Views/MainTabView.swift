import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }
            
            CatalogView()
                .tabItem {
                    Label("Catalog", systemImage: "square.grid.2x2.fill")
                }
            
            AddMomentView()
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
            
            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(.primary)
    }
}
