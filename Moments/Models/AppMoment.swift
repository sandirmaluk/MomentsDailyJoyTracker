import Foundation

struct AppMoment: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let emoji: String
    let date: Date
    let color: String

    init(id: UUID = UUID(), text: String, emoji: String, date: Date = Date(), color: String) {
        self.id = id
        self.text = text
        self.emoji = emoji
        self.date = date
        self.color = color
    }

    init(from entity: Moment) {
        self.id = entity.id ?? UUID()
        self.text = entity.text ?? ""
        self.emoji = entity.emoji ?? ""
        self.date = entity.date ?? Date()
        self.color = entity.color ?? ""
    }
    
    static func generatePastelColor() -> String {
        let pastelColors = [
            "#FFB3BA", "#FFDFBA", "#FFFFBA", "#BAFFC9", "#BAE1FF",
            "#C7BAFF", "#FFBAF1", "#FFC7BA", "#E8FFBA", "#D4FFBA"
        ]
        return pastelColors.randomElement() ?? "#FFB3BA"
    }
    
    static func isValidText(_ text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && text.count <= 25
    }
}
