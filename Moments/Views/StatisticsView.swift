import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Your Moments")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Statistics")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top)
                        
                        if let stats = viewModel.statistics {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Top 5 Moments")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                if stats.topMoments.isEmpty {
                                    Text("No moments yet")
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                } else {
                                    ForEach(stats.topMoments) { moment in
                                        HStack(spacing: 12) {
                                            Text(moment.emoji)
                                                .font(.title)
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(moment.text)
                                                    .font(.body)
                                                    .foregroundColor(.primary)
                                                
                                                Text("\(moment.count) times")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color(.secondarySystemBackground))
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Activity")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                if stats.activities.isEmpty {
                                    Text("No activity yet")
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 4) {
                                            ForEach(stats.activities.prefix(30)) { day in
                                                VStack(spacing: 4) {
                                                    Text(day.date.formatted(.dateTime.day()))
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                    
                                                    Text(day.date.formatted(.dateTime.month(.abbreviated)))
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                    
                                                    Circle()
                                                        .fill(activityColor(for: day.count))
                                                        .frame(width: 12, height: 12)
                                                }
                                                .onTapGesture {
                                                    viewModel.selectDay(day)
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Time Distribution")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 0) {
                                    TimeSegmentView(title: "Morning", count: stats.timeDistribution.morning, color: .orange)
                                    TimeSegmentView(title: "Afternoon", count: stats.timeDistribution.afternoon, color: .yellow)
                                    TimeSegmentView(title: "Evening", count: stats.timeDistribution.evening, color: .blue)
                                    TimeSegmentView(title: "Night", count: stats.timeDistribution.night, color: .purple)
                                }
                                .frame(height: 60)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.separator), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Summary")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    StatCardView(title: "Total Moments", value: "\(stats.totalMoments)", icon: "star.fill")
                                    StatCardView(title: "Current Streak", value: "\(stats.currentStreak)", icon: "flame.fill")
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            VStack(spacing: 20) {
                                ProgressView()
                                    .scaleEffect(1.5)
                                Text("Loading statistics...")
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxHeight: .infinity)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.showDayDetails) {
                DayDetailsView(moments: viewModel.selectedDayMoments)
            }
            .onAppear {
                viewModel.loadStatistics()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemBackground) : Color(.systemGroupedBackground)
    }
    
    private func activityColor(for count: Int) -> Color {
        switch count {
        case 0: return Color(.tertiarySystemBackground)
        case 1: return Color.green.opacity(0.3)
        case 2: return Color.green.opacity(0.5)
        case 3: return Color.green.opacity(0.7)
        default: return Color.green
        }
    }
}

struct TimeSegmentView: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        if count > 0 {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.3))
                    
                    VStack {
                        Text(title)
                            .font(.caption2)
                            .foregroundColor(.primary)
                        
                        Text("\(count)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.primary)
            
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct DayDetailsView: View {
    let moments: [AppMoment]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(moments) { moment in
                HStack(spacing: 12) {
                    Text(moment.emoji)
                        .font(.title)
                    
                    Text(moment.text)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(moment.date.formatted(.dateTime.hour().minute()))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationBarTitle("Moments", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
