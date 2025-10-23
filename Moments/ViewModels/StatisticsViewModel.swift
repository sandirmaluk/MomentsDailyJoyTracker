import Foundation
import Combine

class StatisticsViewModel: ObservableObject {
    @Published var statistics: Statistics?
    @Published var selectedDayMoments: [AppMoment] = []
    @Published var showDayDetails = false
    
    private let dataService = DataService.shared
    
    init() {
        loadStatistics()
    }
    
    func loadStatistics() {
        let allMoments = dataService.fetchAllMoments()
        statistics = Statistics(moments: allMoments)
    }
    
    func selectDay(_ day: DayActivity) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: day.date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? Date.distantFuture

        selectedDayMoments = dataService.fetchAllMoments().filter { moment in
            moment.date >= startOfDay && moment.date < endOfDay
        }
        showDayDetails = true
    }
    
    func refreshStatistics() {
        loadStatistics()
    }
}
