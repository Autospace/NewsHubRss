import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    @AppStorage(AppSettings.useReaderInSafari.rawValue) var useReaderInSafari: Bool = true
    typealias UIViewControllerType = SFSafariViewController
    var url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = useReaderInSafari
        return SFSafariViewController(url: url, configuration: configuration)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {

    }
}

#Preview {
    SafariView(url: URL(string: "https://www.indiehackers.com/post/34-year-old-finds-financial-freedom-through-day-trading-and-uses-it-to-build-a-10k-mo-fintech-product-PujthWlU8L3nS4mz2GSc")!)
}
