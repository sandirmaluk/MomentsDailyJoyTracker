import Foundation
import Combine

class TodayViewModel: ObservableObject {
    @Published var todaysMoments: [AppMoment] = []
    @Published var showAddMomentView = false
    @Published var inspirationalQuote = ""
    @Published var userSettings: AppUserSettings?
    @Published var showGoalCelebration = false
    
    private let dataService = DataService.shared
    private let quotes = [
        "Every moment matters",
        "Find joy in the little things",
        "Appreciate the present",
        "Small moments make big memories",
        "Happiness is in the details",
        "Live in the moment",
        "Cherish every second",
        "Find beauty in simplicity",
        "Moments create memories",
        "Be present, be happy"
    ]
    
    init() {
        loadTodaysMoments()
        loadUserSettings()
        inspirationalQuote = quotes.randomElement() ?? "Every moment matters"
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
        inspirationalQuote = quotes.randomElement() ?? "Every moment matters"
    }
}
