import Foundation
import Combine

class TodayViewModel: ObservableObject {
    @Published var todaysMoments: [AppMoment] = []
    @Published var showAddMomentView = false
    @Published var inspirationalQuote = ""
    @Published var userSettings: AppUserSettings?
    @Published var showGoalCelebration = false
    
    private let dataService = DataService.shared
    
    private var quotes: [String] {
        [
            "Every moment matters".localized,
            "Find joy in the little things".localized,
            "Appreciate the present".localized,
            "Small moments make big memories".localized,
            "Happiness is in the details".localized,
            "Live in the moment".localized,
            "Cherish every second".localized,
            "Find beauty in simplicity".localized,
            "Moments create memories".localized,
            "Be present, be happy".localized
        ]
    }
    
    init() {
        loadTodaysMoments()
        loadUserSettings()
        inspirationalQuote = quotes.randomElement() ?? "Every moment matters".localized
    }
    
    func loadTodaysMoments() {
        todaysMoments = dataService.fetchMomentsForDate(Date())
    }
    
    func loadUserSettings() {
        userSettings = dataService.getUserSettings()
    }
    
    var isDailyGoalEnabled: Bool {
        return userSettings?.dailyGoal ?? false
    }
    
    var isDailyGoalCompleted: Bool {
        return isDailyGoalEnabled && !todaysMoments.isEmpty
    }
    
    func addMoment(text: String, emoji: String) {
        guard AppMoment.isValidText(text) else { return }

        let wasGoalIncomplete = isDailyGoalEnabled && todaysMoments.isEmpty

        let moment = AppMoment(
            text: text,
            emoji: emoji,
            color: AppMoment.generatePastelColor()
        )

        dataService.saveMoment(moment)
        loadTodaysMoments()
        
        if wasGoalIncomplete {
            showGoalCelebration = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showGoalCelebration = false
            }
        }
    }

    func addMomentFromCatalog(_ catalogMoment: AppMoment) {
        let newMoment = AppMoment(
            text: catalogMoment.text,
            emoji: catalogMoment.emoji,
            color: AppMoment.generatePastelColor()
        )

        dataService.saveMoment(newMoment)
        loadTodaysMoments()
    }

    func deleteMoment(_ moment: AppMoment) {
        dataService.deleteMoment(moment)
        loadTodaysMoments()
    }
    
    func refreshQuote() {
        inspirationalQuote = quotes.randomElement() ?? "Every moment matters".localized
    }
}
