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

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://devby.io")!)
    }
}
