import SwiftUI

struct EditFeedView: View {
    @State private var feedTitle: String = ""
    let feedLink: String
    let saveHandler: ((_ title: String) -> Void)

    init(feedTitle: String, feedLink: String, saveHandler: @escaping (_: String) -> Void) {
        self.feedTitle = feedTitle
        self.feedLink = feedLink
        self.saveHandler = saveHandler
    }

    var body: some View {
        VStack {
            CommonTextFieldView(
                text: $feedTitle,
                placeholder: L10n.AddNewFeed.EditView.feedTitlePlaceholder
            )
            Text(feedLink)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)

            Spacer()

            Button {
                saveHandler(feedTitle)
            } label: {
                Text(L10n.Common.save)
            }
        }
        .padding()
    }
}

#Preview {
    EditFeedView(
        feedTitle: "Test title",
        feedLink: "https://test.link",
        saveHandler: { _ in}
    )
}
