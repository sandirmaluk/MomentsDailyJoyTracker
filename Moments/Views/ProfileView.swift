import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(spacing: 20) {
                            Button(action: {
                                viewModel.showImagePicker = true
                            }) {
                                if let profileImage = viewModel.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.primary, lineWidth: 2))
                                } else {
                                    ZStack {
                                        Circle()
                                            .fill(Color(.secondarySystemBackground))
                                            .frame(width: 100, height: 100)
                                        
                                        Image(systemName: "person.circle.fill")
                                            .font(.system(size: 80))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.primary)
                                    .clipShape(Circle())
                                    .offset(x: 35, y: -35)
                            }
                            
                            VStack(spacing: 8) {
                                if let userName = viewModel.userSettings.userName {
                                    Text(userName)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                } else {
                                    Text("Moments User")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                }
                                
                                Button(action: {
                                    viewModel.showNameEditor = true
                                }) {
                                    Text("Edit name")
                                        .font(.subheadline)
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                        
                        VStack(spacing: 0) {
                            Toggle(isOn: $viewModel.userSettings.dailyGoal) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Daily Goal")
                                        .foregroundColor(.primary)
                                    Text("Set a goal to add at least 1 moment per day")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .onChange(of: viewModel.userSettings.dailyGoal) { _ in
                                viewModel.toggleDailyGoal()
                            }
                            
                            Divider()
                                .padding(.leading)
                            
                            Toggle(isOn: $viewModel.userSettings.notificationsEnabled) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Notifications")
                                        .foregroundColor(.primary)
                                    Text("Get reminded to add moments")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .onChange(of: viewModel.userSettings.notificationsEnabled) { _ in
                                viewModel.toggleNotifications()
                            }
                            
                            if viewModel.userSettings.notificationsEnabled {
                                Divider()
                                    .padding(.leading)
                                
                                Button(action: {
                                    viewModel.showTimePicker = true
                                }) {
                                    HStack {
                                        Text("Reminder Time")
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        if let time = viewModel.userSettings.notificationTime {
                                            Text(time.formatted(.dateTime.hour().minute()))
                                                .foregroundColor(.secondary)
                                        } else {
                                            Text("Not set")
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                }
                            }
                        }
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About Moments")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Moments helps you notice and appreciate the little things that make life beautiful. Every moment counts, no matter how small.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(4)
                            
                            Text("Thank you for using Moments!")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.top, 8)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                viewModel.exportAllData()
                                if viewModel.exportData != nil {
                                    let activityVC = UIActivityViewController(activityItems: [viewModel.exportData!], applicationActivities: nil)
                                    
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let window = windowScene.windows.first,
                                       let rootViewController = window.rootViewController {
                                        rootViewController.present(activityVC, animated: true, completion: nil)
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.primary)
                                    
                                    Text("Export Data")
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                viewModel.showClearDataAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                    
                                    Text("Clear All Data")
                                        .foregroundColor(.red)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.showNameEditor) {
                NameEditorView(userName: viewModel.userSettings.userName ?? "") { newName in
                    viewModel.saveUserName(newName)
                }
            }
            .sheet(isPresented: $viewModel.showTimePicker) {
                TimePickerView(selectedTime: viewModel.userSettings.notificationTime) { time in
                    viewModel.saveNotificationTime(time)
                }
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(selectedImage: Binding(
                    get: { viewModel.profileImage },
                    set: { newImage in
                        if let image = newImage {
                            viewModel.saveProfileImage(image)
                        }
                    }
                ))
            }
            .alert("Clear All Data", isPresented: $viewModel.showClearDataAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    viewModel.clearAllData()
                }
            } message: {
                Text("Are you sure you want to delete all moments and reset settings? This action cannot be undone.")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemBackground) : Color(.systemGroupedBackground)
    }
}

struct NameEditorView: View {
    @State private var userName: String
    let onSave: (String) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    init(userName: String, onSave: @escaping (String) -> Void) {
        _userName = State(initialValue: userName)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter your name", text: $userName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    onSave(userName)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.top)
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Edit Name", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct TimePickerView: View {
    @State private var selectedTime: Date
    let onSave: (Date) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    init(selectedTime: Date?, onSave: @escaping (Date) -> Void) {
        _selectedTime = State(initialValue: selectedTime ?? Date())
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Reminder Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                
                Spacer()
                
                Button(action: {
                    onSave(selectedTime)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Set Time")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.top)
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Set Reminder Time", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
