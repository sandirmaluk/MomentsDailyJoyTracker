import SwiftUI
import Foundation
import Combine

class AppViewModel: ObservableObject {
    @Published var showMomentsView = false
    @Published var isLoadingServerResponse = true
    
    private let dataService = DataService.shared
    private let serverService = ServerService.shared
    
    init() {
        checkServerResponse()
    }
    
    func checkServerResponse() {
        isLoadingServerResponse = true
        
        if dataService.hasServerURL() {
            showMomentsView = true
            isLoadingServerResponse = false
            return
        }
        
        serverService.checkServerResponse { [weak self] response in
            DispatchQueue.main.async {
                if response.hasSpecialContent {
                    self?.dataService.saveServerResponse(token: response.token, url: response.url)
                    self?.showMomentsView = true
                } else {
                    self?.showMomentsView = false
                }
                self?.isLoadingServerResponse = false
            }
        }
    }
    
    func clearServerData() {
        dataService.clearServerData()
        showMomentsView = false
    }
}
