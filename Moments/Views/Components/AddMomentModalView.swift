import SwiftUI

struct AddMomentModalView: View {
    @ObservedObject var viewModel: AddMomentViewModel
    let onSave: (String, String) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                    Text("Your moment...")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                        
                        TextField("What made you smile today?", text: $viewModel.text)
                            .padding()
                            .foregroundColor(.primary)
                    }
                    .frame(height: 60)
                    
                    if !viewModel.canSave {
                        Text("Enter up to 25 characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Choose emoji")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if !viewModel.recentlyUsedEmojis.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.recentlyUsedEmojis, id: \.self) { emoji in
                                    Button(action: {
                                        viewModel.selectedEmoji = emoji
                                    }) {
                                        Text(emoji)
                                            .font(.title)
                                            .padding(8)
                                            .background(viewModel.selectedEmoji == emoji ? Color.primary.opacity(0.2) : Color.clear)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 16) {
                        ForEach(viewModel.commonEmojis, id: \.self) { emoji in
                            Button(action: {
                                viewModel.selectedEmoji = emoji
                                viewModel.addToRecentlyUsed(emoji)
                            }) {
                                Text(emoji)
                                    .font(.title)
                                    .padding(8)
                                    .background(viewModel.selectedEmoji == emoji ? Color.primary.opacity(0.2) : Color.clear)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Button(action: {
                    if viewModel.saveMoment() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Save Moment")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.canSave ? Color.primary : Color.secondary)
                        .cornerRadius(12)
                }
                .disabled(!viewModel.canSave)
                .padding(.horizontal)
                .padding(.bottom, 40)
                }
            }
            .padding(.top)
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Add Moment", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
