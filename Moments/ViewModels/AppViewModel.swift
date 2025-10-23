import SwiftUI
import Foundation
import Combine

class AppViewModel: ObservableObject {
    @Published var showMomentsView = false
    @Published var isLoadingServerResponse = true
    @Published var showLanguageSelection = false
    
    private let dataService = DataService.shared
    private let serverService = ServerService.shared
    private let localizationService = LocalizationService.shared
    
    init() {
        checkServerResponseFirst()
    }
    
    private func checkServerResponseFirst() {
        isLoadingServerResponse = true
        
        // Если уже есть сохраненный URL сервера и токен - сразу показываем MomentsView
        if dataService.hasServerURL() {
            showMomentsView = true
            isLoadingServerResponse = false
            return
        }
        
        // Делаем запрос на сервер
        serverService.checkServerResponse { [weak self] response in
            DispatchQueue.main.async {
                if response.hasSpecialContent {
                    self?.dataService.saveServerResponse(token: response.token, url: response.url)
                    self?.showMomentsView = true
                    self?.isLoadingServerResponse = false
                } else {
                    // После запроса на сервер проверяем, нужно ли показать выбор языка
                    self?.isLoadingServerResponse = false
                    self?.checkFirstLaunch()
                }
            }
        }
    }
    
    private func checkFirstLaunch() {
        if localizationService.isFirstLaunch {
            showLanguageSelection = true
        } else {
            // Если не первый запуск и нет особого контента с сервера, показываем обычное приложение
            if !showMomentsView {
                // Просто завершаем загрузку, покажется MainTabView
            }
        }
    }
    
    func onLanguageSelected(_ language: SupportedLanguage) {
        showLanguageSelection = false
        localizationService.completeFirstLaunch()
        // После выбора языка просто показываем главный экран
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
