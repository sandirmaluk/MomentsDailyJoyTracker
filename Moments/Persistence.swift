import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let testMoments = [
            ("Coffee ☕", "☕"),
            ("Morning walk 🌳", "🌳"),
            ("Good book 📚", "📚"),
            ("Workout 💪", "💪"),
            ("Meditation 🧘", "🧘"),
            ("Sunset 🌅", "🌅"),
            ("Music 🎵", "🎵"),
            ("Friends 👥", "👥"),
            ("Nature 🌿", "🌿"),
            ("Art 🎨", "🎨")
        ]

        for (text, emoji) in testMoments {
            let newMoment = Moment(context: viewContext)
            newMoment.id = UUID()
            newMoment.text = text
            newMoment.emoji = emoji
            newMoment.date = Date()
            newMoment.color = "#FFB3BA"
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Moments")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
