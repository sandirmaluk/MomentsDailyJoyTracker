import Foundation
import Combine

class CatalogViewModel: ObservableObject {
    @Published var catalogMoments: [AppMoment] = []
    @Published var searchText = ""
    @Published var showAddMomentView = false
    
    private let dataService = DataService.shared
    
    init() {
        loadCatalogMoments()
    }
    
    func loadCatalogMoments() {
        catalogMoments = dataService.fetchUniqueMoments()
    }
    
    func addMomentToToday(_ moment: AppMoment) {
        let newMoment = AppMoment(
            text: moment.text,
            emoji: moment.emoji,
            color: AppMoment.generatePastelColor()
        )

        dataService.saveMoment(newMoment)
    }
    
    var filteredMoments: [AppMoment] {
        if searchText.isEmpty {
            return catalogMoments
        }
        return catalogMoments.filter { moment in
            moment.text.lowercased().contains(searchText.lowercased()) ||
            moment.emoji.contains(searchText)
        }
    }
}
