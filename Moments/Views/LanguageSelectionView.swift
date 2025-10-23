import SwiftUI

struct LanguageSelectionView: View {
    let onLanguageSelected: (SupportedLanguage) -> Void
    
    @StateObject private var localizationService = LocalizationService.shared
    @State private var selectedLanguage: SupportedLanguage = .englishUS
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // App Title
                Text("Moments")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Subtitle
                Text("Choose your language")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // Device Language Info
                if let deviceLanguage = getDeviceLanguage() {
                    VStack(spacing: 8) {
                        Text("Your device language:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(deviceLanguage.nativeName)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                // Language Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select Language")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(SupportedLanguage.allCases, id: \.self) { language in
                                Button(action: {
                                    selectedLanguage = language
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(language.nativeName)
                                                .font(.body)
                                                .fontWeight(.medium)
                                                .foregroundColor(.primary)
                                            
                                            Text(language.displayName)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        if selectedLanguage == language {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedLanguage == language ? Color.blue.opacity(0.1) : Color.clear)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    localizationService.setLanguage(selectedLanguage)
                    localizationService.completeFirstLaunch()
                    onLanguageSelected(selectedLanguage)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationBarHidden(true)
        }
        .onAppear {
            selectedLanguage = localizationService.getDeviceLanguage()
        }
    }
    
    private func getDeviceLanguage() -> SupportedLanguage? {
        return localizationService.getDeviceLanguage()
    }
}

#Preview {
    LanguageSelectionView { _ in }
}