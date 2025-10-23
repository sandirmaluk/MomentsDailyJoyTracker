import Foundation
import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var userSettings: AppUserSettings
    @Published var showNameEditor = false
    @Published var showTimePicker = false
    @Published var tempUserName = ""
    @Published var exportData: String? = nil
    @Published var showImagePicker = false
    @Published var profileImage: UIImage? = nil
    @Published var showClearDataAlert = false
    @Published var showLanguageSelector = false
    
    private let dataService = DataService.shared
    private let userDefaults = UserDefaults.standard
    private let notificationService = NotificationService.shared
    
    init() {
        if let settings = dataService.getUserSettings() {
            userSettings = settings
        } else {
            userSettings = AppUserSettings()
            dataService.saveUserSettings(userSettings)
        }
        
        loadProfileImage()
        
        if userSettings.notificationsEnabled, let notificationTime = userSettings.notificationTime {
            notificationService.checkAuthorizationStatus { [weak self] authorized in
                if authorized {
                    self?.notificationService.scheduleDailyNotification(at: notificationTime)
                } else {
                    self?.userSettings.notificationsEnabled = false
                    if let settings = self?.userSettings {
                        self?.dataService.saveUserSettings(settings)
                    }
                }
            }
        }
    }
    
    func saveUserName(_ name: String) {
        userSettings.userName = name.isEmpty ? nil : name
        dataService.saveUserSettings(userSettings)
    }
    
    func toggleDailyGoal() {
        userSettings.dailyGoal.toggle()
        dataService.saveUserSettings(userSettings)
    }
    
    func toggleNotifications() {
        let wasEnabled = userSettings.notificationsEnabled
        userSettings.notificationsEnabled.toggle()
        
        if userSettings.notificationsEnabled && !wasEnabled {
            notificationService.requestAuthorization { [weak self] granted in
                guard let self = self else { return }
                
                if granted {
                    if let time = self.userSettings.notificationTime {
                        self.notificationService.scheduleDailyNotification(at: time)
                    } else {
                        let calendar = Calendar.current
                        var components = calendar.dateComponents([.year, .month, .day], from: Date())
                        components.hour = 20
                        components.minute = 0
                        if let defaultTime = calendar.date(from: components) {
                            self.userSettings.notificationTime = defaultTime
                            self.notificationService.scheduleDailyNotification(at: defaultTime)
                        }
                    }
                    self.dataService.saveUserSettings(self.userSettings)
                } else {
                    self.userSettings.notificationsEnabled = false
                    self.dataService.saveUserSettings(self.userSettings)
                }
            }
        } else if !userSettings.notificationsEnabled {
            notificationService.cancelAllNotifications()
            dataService.saveUserSettings(userSettings)
        } else {
            dataService.saveUserSettings(userSettings)
        }
    }
    
    func saveNotificationTime(_ time: Date) {
        userSettings.notificationTime = time
        dataService.saveUserSettings(userSettings)
        
        if userSettings.notificationsEnabled {
            notificationService.scheduleDailyNotification(at: time)
        }
    }
    
    func exportAllData() {
        let moments = dataService.fetchAllMoments()
        let settings = dataService.getUserSettings()

        let exportDataStruct = ExportData(moments: moments, settings: settings)

        do {
            let jsonData = try JSONEncoder().encode(exportDataStruct)
            exportData = String(data: jsonData, encoding: .utf8)
        } catch {
            exportData = nil
        }
    }
    
    func clearAllData() {
        dataService.clearAllMoments()
        dataService.clearUserSettings()
        profileImage = nil
        userDefaults.removeObject(forKey: "profileImage")
        userSettings = AppUserSettings()
        dataService.saveUserSettings(userSettings)
        notificationService.cancelAllNotifications()
    }
    
    func saveProfileImage(_ image: UIImage) {
        profileImage = image
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            userDefaults.set(imageData, forKey: "profileImage")
        }
    }
    
    func loadProfileImage() {
        if let imageData = userDefaults.data(forKey: "profileImage"),
           let image = UIImage(data: imageData) {
            profileImage = image
        }
    }
}

struct ExportData: Codable {
    let moments: [AppMoment]
    let settings: AppUserSettings?
    let exportDate: Date

    init(moments: [AppMoment], settings: AppUserSettings?) {
        self.moments = moments
        self.settings = settings
        self.exportDate = Date()
    }
}
