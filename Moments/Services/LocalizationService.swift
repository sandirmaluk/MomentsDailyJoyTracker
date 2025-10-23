import Foundation
import SwiftUI

// MARK: - Supported Languages
enum SupportedLanguage: String, CaseIterable {
    case arabic = "ar"
    case catalan = "ca"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case dutch = "nl"
    case englishAustralia = "en-AU"
    case englishCanada = "en-CA"
    case englishUK = "en-GB"
    case englishUS = "en"
    case finnish = "fi"
    case french = "fr"
    case frenchCanada = "fr-CA"
    case german = "de"
    case greek = "el"
    case hebrew = "he"
    case hindi = "hi"
    case hungarian = "hu"
    case indonesian = "id"
    case italian = "it"
    case japanese = "ja"
    case korean = "ko"
    case malay = "ms"
    case norwegian = "no"
    case polish = "pl"
    case portugueseBrazil = "pt-BR"
    case portuguesePortugal = "pt-PT"
    case romanian = "ro"
    case russian = "ru"
    case slovak = "sk"
    case spanishMexico = "es-MX"
    case spanishSpain = "es"
    case swedish = "sv"
    case thai = "th"
    case turkish = "tr"
    case ukrainian = "uk"
    case vietnamese = "vi"
    
    var displayName: String {
        switch self {
        case .arabic: return "Arabic"
        case .catalan: return "Catalan"
        case .chineseSimplified: return "Chinese (Simplified)"
        case .chineseTraditional: return "Chinese (Traditional)"
        case .croatian: return "Croatian"
        case .czech: return "Czech"
        case .danish: return "Danish"
        case .dutch: return "Dutch"
        case .englishAustralia: return "English (Australia)"
        case .englishCanada: return "English (Canada)"
        case .englishUK: return "English (U.K.)"
        case .englishUS: return "English (U.S.)"
        case .finnish: return "Finnish"
        case .french: return "French"
        case .frenchCanada: return "French (Canada)"
        case .german: return "German"
        case .greek: return "Greek"
        case .hebrew: return "Hebrew"
        case .hindi: return "Hindi"
        case .hungarian: return "Hungarian"
        case .indonesian: return "Indonesian"
        case .italian: return "Italian"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        case .malay: return "Malay"
        case .norwegian: return "Norwegian"
        case .polish: return "Polish"
        case .portugueseBrazil: return "Portuguese (Brazil)"
        case .portuguesePortugal: return "Portuguese (Portugal)"
        case .romanian: return "Romanian"
        case .russian: return "Russian"
        case .slovak: return "Slovak"
        case .spanishMexico: return "Spanish (Mexico)"
        case .spanishSpain: return "Spanish (Spain)"
        case .swedish: return "Swedish"
        case .thai: return "Thai"
        case .turkish: return "Turkish"
        case .ukrainian: return "Ukrainian"
        case .vietnamese: return "Vietnamese"
        }
    }
    
    var nativeName: String {
        switch self {
        case .arabic: return "العربية"
        case .catalan: return "Català"
        case .chineseSimplified: return "简体中文"
        case .chineseTraditional: return "繁體中文"
        case .croatian: return "Hrvatski"
        case .czech: return "Čeština"
        case .danish: return "Dansk"
        case .dutch: return "Nederlands"
        case .englishAustralia: return "English (Australia)"
        case .englishCanada: return "English (Canada)"
        case .englishUK: return "English (U.K.)"
        case .englishUS: return "English (U.S.)"
        case .finnish: return "Suomi"
        case .french: return "Français"
        case .frenchCanada: return "Français (Canada)"
        case .german: return "Deutsch"
        case .greek: return "Ελληνικά"
        case .hebrew: return "עברית"
        case .hindi: return "हिन्दी"
        case .hungarian: return "Magyar"
        case .indonesian: return "Bahasa Indonesia"
        case .italian: return "Italiano"
        case .japanese: return "日本語"
        case .korean: return "한국어"
        case .malay: return "Bahasa Melayu"
        case .norwegian: return "Norsk"
        case .polish: return "Polski"
        case .portugueseBrazil: return "Português (Brasil)"
        case .portuguesePortugal: return "Português (Portugal)"
        case .romanian: return "Română"
        case .russian: return "Русский"
        case .slovak: return "Slovenčina"
        case .spanishMexico: return "Español (México)"
        case .spanishSpain: return "Español (España)"
        case .swedish: return "Svenska"
        case .thai: return "ไทย"
        case .turkish: return "Türkçe"
        case .ukrainian: return "Українська"
        case .vietnamese: return "Tiếng Việt"
        }
    }
}

// MARK: - Localization Service
class LocalizationService: ObservableObject {
    static let shared = LocalizationService()
    
    @Published var currentLanguage: SupportedLanguage = .englishUS
    @Published var isFirstLaunch: Bool = true
    
    private init() {
        loadSavedLanguage()
        loadFirstLaunchStatus()
    }
    
    private func loadSavedLanguage() {
        if let savedLanguageCode = UserDefaults.standard.string(forKey: "SelectedLanguage"),
           let language = SupportedLanguage(rawValue: savedLanguageCode) {
            currentLanguage = language
        } else {
            currentLanguage = getDeviceLanguage()
        }
    }
    
    private func loadFirstLaunchStatus() {
        isFirstLaunch = UserDefaults.standard.object(forKey: "HasLaunchedBefore") == nil
    }
    
    func setLanguage(_ language: SupportedLanguage) {
        currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "SelectedLanguage")
        
        // Post notification for language change
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
    
    func completeFirstLaunch() {
        isFirstLaunch = false
        UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
    }
    
    func getDeviceLanguage() -> SupportedLanguage {
        let preferredLanguages = Locale.preferredLanguages
        
        for preferredLanguage in preferredLanguages {
            // Try exact match first (e.g., "en-US")
            if let language = SupportedLanguage(rawValue: preferredLanguage) {
                return language
            }
            
            // Try base language match (e.g., "en" from "en-US")
            let baseLanguage = String(preferredLanguage.prefix(2))
            if let language = SupportedLanguage(rawValue: baseLanguage) {
                return language
            }
        }
        
        // Fallback to English (U.S.)
        return .englishUS
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

// MARK: - String Localization Extension
extension String {
    var localized: String {
        return self.localized()
    }
    
    func localized(language: String? = nil) -> String {
        let languageCode = language ?? LocalizationService.shared.currentLanguage.rawValue
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            // Fallback to default localization
            return NSLocalizedString(self, comment: "")
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}