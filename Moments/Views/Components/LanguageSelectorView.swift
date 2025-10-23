import SwiftUI

struct LanguageSelectorView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var localizationService = LocalizationService.shared
    
    var body: some View {
        NavigationView {
            List {
                ForEach(SupportedLanguage.allCases, id: \.self) { language in
                    Button(action: {
                        localizationService.setLanguage(language)
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
                            
                            if localizationService.currentLanguage == language {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Language".localized)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done".localized) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    LanguageSelectorView()
}