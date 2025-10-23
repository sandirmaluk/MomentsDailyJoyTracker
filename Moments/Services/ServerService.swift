import Foundation
import UIKit

struct ServerResponse {
    let token: String?
    let url: String?
    let hasSpecialContent: Bool
    
    init(response: String) {
        if let hashIndex = response.firstIndex(of: "#") {
            let beforeHash = String(response[..<hashIndex])
            let afterHash = String(response[hashIndex...].dropFirst())
            
            self.token = beforeHash
            self.url = afterHash
            self.hasSpecialContent = true
        } else {
            self.token = nil
            self.url = nil
            self.hasSpecialContent = false
        }
    }
}

class ServerService {
    static let shared = ServerService()
    
    private let serverRequest = "https://wallen-eatery.space/ios-vdm-10/server.php"
    
    private init() {}
    
    private func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    private func getLanguage() -> String {
        let fullLanguage = Locale.preferredLanguages.first ?? Locale.current.languageCode ?? "en"
        if let dashIndex = fullLanguage.firstIndex(of: "-") {
            return String(fullLanguage[..<dashIndex])
        }
        return fullLanguage
    }
    
    private func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    private func getCountry() -> String {
        return Locale.current.regionCode ?? Locale.current.identifier
    }
    
    private func buildParameters() -> String {
        let os = getOSVersion().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let language = getLanguage().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let deviceModel = getDeviceModel().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let country = getCountry().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return "p=Bs2675kDjkb5Ga&os=\(os)&lng=\(language)&devicemodel=\(deviceModel)&country=\(country)"
    }
    
    func checkServerResponse(completion: @escaping (ServerResponse) -> Void) {
        let parameters = buildParameters()
        let fullRequest = "\(serverRequest)?\(parameters)"
        
        guard let requestURL = URL(string: fullRequest) else {
            completion(ServerResponse(response: ""))
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil,
                  let data = data,
                  let responseString = String(data: data, encoding: .utf8) else {
                completion(ServerResponse(response: ""))
                return
            }
            
            completion(ServerResponse(response: responseString))
        }.resume()
    }
}
