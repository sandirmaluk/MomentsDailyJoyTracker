import CoreData
import Foundation

class DataService {
    static let shared = DataService()
    
    private let persistenceController = PersistenceController.shared
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func fetchAllMoments() -> [AppMoment] {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Moment> = Moment.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Moment.date, ascending: false)]

        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map { AppMoment(from: $0) }
        } catch {
            return []
        }
    }

    func fetchMomentsForDate(_ date: Date) -> [AppMoment] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? Date.distantFuture

        return fetchAllMoments().filter { moment in
            moment.date >= startOfDay && moment.date < endOfDay
        }
    }

    func fetchUniqueMoments() -> [AppMoment] {
        let allMoments = fetchAllMoments()
        let uniqueTexts = Set(allMoments.map { "\($0.emoji) \($0.text)" })

        return uniqueTexts.compactMap { text in
            allMoments.first { "\($0.emoji) \($0.text)" == text }
        }.sorted { first, second in
            let firstCount = allMoments.filter { "\($0.emoji) \($0.text)" == "\(first.emoji) \(first.text)" }.count
            let secondCount = allMoments.filter { "\($0.emoji) \($0.text)" == "\(second.emoji) \(second.text)" }.count
            return firstCount > secondCount
        }
    }

    func saveMoment(_ moment: AppMoment) {
        let context = persistenceController.container.viewContext

        let entity = Moment(context: context)
        entity.id = moment.id
        entity.text = moment.text
        entity.emoji = moment.emoji
        entity.date = moment.date
        entity.color = moment.color

        do {
            try context.save()
        } catch {
        }
    }

    func deleteMoment(_ moment: AppMoment) {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Moment> = Moment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", moment.id as CVarArg)

        do {
            let entities = try context.fetch(fetchRequest)
            entities.forEach { context.delete($0) }
            try context.save()
        } catch {
        }
    }

    func getUserSettings() -> AppUserSettings? {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()

        do {
            let entities = try context.fetch(fetchRequest)
            return entities.first.map { AppUserSettings(from: $0) }
        } catch {
            return nil
        }
    }

    func saveUserSettings(_ settings: AppUserSettings) {
        let context = persistenceController.container.viewContext

        let fetchRequest: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            entities.forEach { context.delete($0) }
        } catch {
        }

        let entity = UserSettings(context: context)
        entity.id = settings.id
        entity.userName = settings.userName
        entity.dailyGoal = settings.dailyGoal
        entity.notificationsEnabled = settings.notificationsEnabled
        entity.notificationTime = settings.notificationTime
        entity.serverToken = settings.serverToken
        entity.serverLink = settings.serverLink

        do {
            try context.save()
        } catch {
        }
    }
    
    func hasServerURL() -> Bool {
        return userDefaults.string(forKey: "serverLink") != nil
    }
    
    func getServerURL() -> String? {
        return userDefaults.string(forKey: "serverLink")
    }
    
    func saveServerResponse(token: String?, url: String?) {
        if let token = token {
            userDefaults.set(token, forKey: "serverToken")
        }
        if let url = url {
            userDefaults.set(url, forKey: "serverLink")
        }
    }
    
    func clearServerData() {
        userDefaults.removeObject(forKey: "serverToken")
        userDefaults.removeObject(forKey: "serverLink")
    }
    
    func clearAllMoments() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Moment> = Moment.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            entities.forEach { context.delete($0) }
            try context.save()
        } catch {
        }
    }
    
    func clearUserSettings() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            entities.forEach { context.delete($0) }
            try context.save()
        } catch {
        }
    }
}
