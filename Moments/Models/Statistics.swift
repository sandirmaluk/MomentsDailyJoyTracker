import Foundation

struct TopMoment: Identifiable {
    let id = UUID()
    let text: String
    let emoji: String
    let count: Int
}

struct DayActivity: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct TimeDistribution {
    let morning: Int
    let afternoon: Int
    let evening: Int
    let night: Int
}

struct Statistics {
    let topMoments: [TopMoment]
    let activities: [DayActivity]
    let timeDistribution: TimeDistribution
    let totalMoments: Int
    let currentStreak: Int

    init(moments: [AppMoment]) {
        self.totalMoments = moments.count
        
        let momentCounts = Dictionary(grouping: moments, by: { "\($0.emoji) \($0.text)" })
            .map { TopMoment(text: $0.key, emoji: $0.key.components(separatedBy: " ").first ?? "", count: $0.value.count) }
            .sorted { $0.count > $1.count }
        
        self.topMoments = Array(momentCounts.prefix(5))
        
        let calendar = Calendar.current
        let dayCounts = Dictionary(grouping: moments) { calendar.startOfDay(for: $0.date) }
            .map { DayActivity(date: $0.key, count: $0.value.count) }
            .sorted { $0.date < $1.date }

        self.activities = dayCounts

        let hourCounts = moments.reduce(into: [Int: Int]()) { counts, moment in
            let hour = calendar.component(.hour, from: moment.date)
            let key = hour
            counts[key, default: 0] += 1
        }
        
        let morning = (6...11).reduce(0) { $0 + (hourCounts[$1] ?? 0) }
        let afternoon = (12...17).reduce(0) { $0 + (hourCounts[$1] ?? 0) }
        let evening = (18...23).reduce(0) { $0 + (hourCounts[$1] ?? 0) }
        let night = (0...5).reduce(0) { $0 + (hourCounts[$1] ?? 0) }
        
        self.timeDistribution = TimeDistribution(morning: morning, afternoon: afternoon, evening: evening, night: night)
        
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var checkDate = today

        while true {
            let dayMoments = moments.filter { calendar.startOfDay(for: $0.date) == checkDate }
            if dayMoments.isEmpty {
                break
            }
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? Date.distantPast
        }
        
        self.currentStreak = streak
    }
}
