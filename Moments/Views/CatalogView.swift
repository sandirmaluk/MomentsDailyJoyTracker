import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel = CatalogViewModel()
    @StateObject private var localizationService = LocalizationService.shared
    @Environment(\.colorScheme) var colorScheme
    @State private var languageRefresh = UUID()
    
    private let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search moments...".localized, text: $viewModel.searchText)
                            .foregroundColor(.primary)
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if viewModel.filteredMoments.isEmpty {
                        Spacer()
                        if viewModel.searchText.isEmpty {
                            emptyStateView
                        } else {
                            noResultsView
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.filteredMoments) { moment in
                                    MomentCardView(moment: moment, isInCatalog: true) {
                                        viewModel.addMomentToToday(moment)
                                        let generator = UIImpactFeedbackGenerator(style: .light)
                                        generator.impactOccurred()
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                viewModel.loadCatalogMoments()
            }
            .onReceive(NotificationCenter.default.publisher(for: .languageChanged)) { _ in
                languageRefresh = UUID()
            }
            .id(languageRefresh)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemBackground) : Color(.systemGroupedBackground)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.grid.2x2.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No moments yet".localized)
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Add your first moment to see it here!".localized)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No moments found".localized)
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Try searching with different keywords".localized)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
