import Foundation

struct AppUserSettings: Identifiable, Codable {
    let id: UUID
    var userName: String?
    var dailyGoal: Bool
    var notificationsEnabled: Bool
    var notificationTime: Date?
    var serverToken: String?
    var serverLink: String?

    init(id: UUID = UUID(),
         userName: String? = nil,
         dailyGoal: Bool = false,
         notificationsEnabled: Bool = false,
         notificationTime: Date? = nil,
         serverToken: String? = nil,
         serverLink: String? = nil) {
        self.id = id
        self.userName = userName
        self.dailyGoal = dailyGoal
        self.notificationsEnabled = notificationsEnabled
        self.notificationTime = notificationTime
        self.serverToken = serverToken
        self.serverLink = serverLink
    }

    init(from entity: UserSettings) {
        self.id = entity.id ?? UUID()
        self.userName = entity.userName
        self.dailyGoal = entity.dailyGoal
        self.notificationsEnabled = entity.notificationsEnabled
        self.notificationTime = entity.notificationTime
        self.serverToken = entity.serverToken
        self.serverLink = entity.serverLink
    }
}
