import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                    .scaleEffect(1.5)
                
                Text("Loading Moments...")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
    }
}
