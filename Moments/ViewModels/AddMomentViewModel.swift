import Foundation
import Combine

class AddMomentViewModel: ObservableObject {
    @Published var text = ""
    @Published var selectedEmoji = "😊"
    @Published var showEmojiPicker = false
    @Published var recentlyUsedEmojis: [String] = []
    
    private let dataService = DataService.shared
    private let userDefaults = UserDefaults.standard
    
    let commonEmojis = [
        "😊", "❤️", "👍", "🎉", "🌟", "✨", "💫", "🌈", "☀️", "🌸",
        "🍕", "☕", "🎵", "📚", "🏃‍♂️", "🧘‍♀️", "🎨", "📸", "🌳", "🏖️",
        "😍", "😂", "🔥", "💯", "👏", "🤩", "😎", "🥰", "😋", "🤗"
    ]
    
    init() {
        loadRecentlyUsedEmojis()
    }
    
    func saveMoment() -> Bool {
        guard AppMoment.isValidText(text) else { return false }

        let moment = AppMoment(
            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
            emoji: selectedEmoji,
            color: AppMoment.generatePastelColor()
        )

        dataService.saveMoment(moment)
        addToRecentlyUsed(selectedEmoji)
        text = ""
        selectedEmoji = "😊"

        return true
    }
    
    func addToRecentlyUsed(_ emoji: String) {
        if !recentlyUsedEmojis.contains(emoji) {
            recentlyUsedEmojis.insert(emoji, at: 0)
            if recentlyUsedEmojis.count > 10 {
                recentlyUsedEmojis = Array(recentlyUsedEmojis.prefix(10))
            }
            saveRecentlyUsedEmojis()
        }
    }
    
    private func loadRecentlyUsedEmojis() {
        recentlyUsedEmojis = userDefaults.stringArray(forKey: "recentlyUsedEmojis") ?? []
    }
    
    private func saveRecentlyUsedEmojis() {
        userDefaults.set(recentlyUsedEmojis, forKey: "recentlyUsedEmojis")
    }
    
    var canSave: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && text.count <= 25
    }
}
