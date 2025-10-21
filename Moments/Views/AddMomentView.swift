import SwiftUI

struct AddMomentView: View {
    @StateObject private var viewModel = AddMomentViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var showSuccessMessage = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("What made you smile today?")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.secondarySystemBackground))
                                        .frame(height: 80)
                                    
                                    TextField("Enter your moment...", text: $viewModel.text)
                                        .focused($isTextFieldFocused)
                                        .padding()
                                        .foregroundColor(.primary)
                                        .font(.body)
                                }
                                
                                if !viewModel.canSave {
                                    Text("Enter up to 25 characters")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Choose an emoji")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                if !viewModel.recentlyUsedEmojis.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Recently used")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 12) {
                                                ForEach(viewModel.recentlyUsedEmojis, id: \.self) { emoji in
                                                    Button(action: {
                                                        viewModel.selectedEmoji = emoji
                                                    }) {
                                                        Text(emoji)
                                                            .font(.title)
                                                            .padding(12)
                                                            .background(viewModel.selectedEmoji == emoji ? Color.primary.opacity(0.2) : Color(.tertiarySystemBackground))
                                                            .clipShape(Circle())
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Popular")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 16) {
                                        ForEach(viewModel.commonEmojis, id: \.self) { emoji in
                                            Button(action: {
                                                viewModel.selectedEmoji = emoji
                                                viewModel.addToRecentlyUsed(emoji)
                                            }) {
                                                Text(emoji)
                                                    .font(.title)
                                                    .padding(12)
                                                    .background(viewModel.selectedEmoji == emoji ? Color.primary.opacity(0.2) : Color(.tertiarySystemBackground))
                                                    .clipShape(Circle())
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            Spacer(minLength: 40)
                            
                            Button(action: {
                                if viewModel.saveMoment() {
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                    
                                    withAnimation {
                                        showSuccessMessage = true
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        withAnimation {
                                            showSuccessMessage = false
                                        }
                                    }
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(viewModel.canSave ? Color.primary : Color.secondary)
                                        .frame(height: 56)
                                    
                                    Text("Save Moment")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                            .disabled(!viewModel.canSave)
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                    .simultaneousGesture(
                        DragGesture().onChanged { _ in
                            isTextFieldFocused = false
                        }
                    )
                }
            .navigationBarHidden(true)
            .onTapGesture {
                isTextFieldFocused = false
            }
            .overlay(
                Group {
                    if showSuccessMessage {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                                Text("Moment saved!")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(radius: 10)
                            .padding(.bottom, 50)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemBackground) : Color(.systemGroupedBackground)
    }
}
