import SwiftUI
import CoreData

@main
struct MomentsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            if appViewModel.showLanguageSelection {
                LanguageSelectionView { language in
                    appViewModel.onLanguageSelected(language)
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else if appViewModel.isLoadingServerResponse {
                LoadingView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else if appViewModel.showMomentsView {
                MomentsView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(appViewModel)
                    .onAppear {
                        NotificationService.shared.resetBadge()
                    }
            }
        }
    }
}
