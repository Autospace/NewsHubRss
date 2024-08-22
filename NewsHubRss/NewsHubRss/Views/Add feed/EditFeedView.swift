import SwiftUI

struct EditFeedView: View {
    @Binding var feedTitle: String
    let feedLink: String

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
        }
        .padding()
    }
}

#Preview {
    EditFeedView(
        feedTitle: Binding.constant("Test title"),
        feedLink: "https://test.link"
    )
}
