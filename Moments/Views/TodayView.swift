import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    private let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Text(formattedDate)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        if viewModel.isDailyGoalEnabled {
                            HStack(spacing: 8) {
                                if viewModel.isDailyGoalCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Daily Goal: ✅ Completed")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.green)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.orange)
                                    Text("Daily Goal: Add 1 moment")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(viewModel.isDailyGoalCompleted ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                            )
                        }
                        
                        Text(viewModel.inspirationalQuote)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            withAnimation {
                                viewModel.refreshQuote()
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.secondary)
                                .padding(8)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground).opacity(0.5))
                    
                    if viewModel.todaysMoments.isEmpty {
                        Spacer()
                        emptyStateView
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.todaysMoments) { moment in
                                    MomentCardView(moment: moment, isInCatalog: false)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                viewModel.deleteMoment(moment)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.showAddMomentView = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.primary)
                                    .frame(width: 60, height: 60)
                                    .shadow(radius: 10)
                                
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundColor(Color(.systemBackground))
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.showAddMomentView, onDismiss: {
                viewModel.loadTodaysMoments()
                viewModel.loadUserSettings()
            }) {
                AddMomentModalView(viewModel: AddMomentViewModel()) { text, emoji in
                    viewModel.addMoment(text: text, emoji: emoji)
                }
            }
            .onAppear {
                viewModel.loadTodaysMoments()
                viewModel.loadUserSettings()
            }
            .overlay(
                Group {
                    if viewModel.showGoalCelebration {
                        ZStack {
                            Color.black.opacity(0.4)
                                .edgesIgnoringSafeArea(.all)
                            
                            VStack(spacing: 20) {
                                Text("🎉")
                                    .font(.system(size: 80))
                                    .scaleEffect(viewModel.showGoalCelebration ? 1.0 : 0.5)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.showGoalCelebration)
                                
                                VStack(spacing: 8) {
                                    Text("Daily Goal Achieved!")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Great job! Keep it up! 💪")
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                            .padding(40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.green)
                                    .shadow(radius: 20)
                            )
                            .padding(40)
                        }
                        .transition(.opacity)
                    }
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemBackground) : Color(.systemGroupedBackground)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: Date()).uppercased()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "sun.max.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No moments today yet")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Tap the + button to add your first moment of the day!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
