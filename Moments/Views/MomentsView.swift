import SwiftUI
import WebKit

struct MomentsView: View {
    @State private var showInitialLoadingIndicator = true
    
    private let dataService = DataService.shared
    private let contentLink: String

    init() {
        self.contentLink = dataService.getServerURL() ?? ""
    }
    
    var body: some View {
        ZStack {
            if let linkAddress = URL(string: contentLink) {
                MomentsViewInternal(linkAddress: linkAddress, showInitialLoadingIndicator: $showInitialLoadingIndicator)
                    .edgesIgnoringSafeArea(.all)
            }
            
            if showInitialLoadingIndicator {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .statusBar(hidden: true)
        .ignoresSafeArea(.all, edges: .all)
        .onAppear {
            AppDelegate.orientationLock = .all
            updateOrientation()
        }
        .onDisappear {
            AppDelegate.orientationLock = .portrait
            updateOrientation()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private func updateOrientation() {
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: AppDelegate.orientationLock))
        }
        
        UIViewController.attemptRotationToDeviceOrientation()
    }
}

struct MomentsViewInternal: UIViewRepresentable {
    let linkAddress: URL
    @Binding var showInitialLoadingIndicator: Bool

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let momentsView = WKWebView(frame: .zero, configuration: configuration)
        momentsView.navigationDelegate = context.coordinator
        momentsView.scrollView.contentInsetAdjustmentBehavior = .never
        momentsView.scrollView.contentInset = .zero
        momentsView.scrollView.scrollIndicatorInsets = .zero
        momentsView.scrollView.bounces = true
        momentsView.backgroundColor = .clear
        momentsView.isOpaque = false
        momentsView.scrollView.backgroundColor = .clear
        momentsView.load(URLRequest(url: linkAddress))
        
        return momentsView
    }

    func updateUIView(_ momentsView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(showInitialLoadingIndicator: $showInitialLoadingIndicator)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var showInitialLoadingIndicator: Bool
        private var isFirstLoad = true

        init(showInitialLoadingIndicator: Binding<Bool>) {
            _showInitialLoadingIndicator = showInitialLoadingIndicator
        }

        func webView(_ momentsView: WKWebView, didFinish navigation: WKNavigation!) {
            if isFirstLoad {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showInitialLoadingIndicator = false
                    self.isFirstLoad = false
                }
            }
        }

        func webView(_ momentsView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            if isFirstLoad {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showInitialLoadingIndicator = false
                    self.isFirstLoad = false
                }
            }
        }
    }
}
