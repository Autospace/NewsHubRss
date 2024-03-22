import SwiftUI

struct FoundFeedView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var viewModel: FoundFeedViewModel

    init(feedTitle: String, feedURLString: String, tapHandler: @escaping () -> Void) {
        _viewModel = StateObject(
            wrappedValue: FoundFeedViewModel(
                feedTitle: feedTitle,
                feedURLString: feedURLString,
                tapHandler: tapHandler
            )
        )
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(viewModel.feedTitle.trimmingCharacters(in: .whitespacesAndNewlines))
                Text(viewModel.feedURLString)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .onTapGesture {
                viewModel.tapHandler()
            }

            Spacer()

            if viewModel.feedAlreadySaved {
                Button(action: {
                    viewModel.deleteFeed()
                }, label: {
                    Image(uiImage: Asset.checkmarkIcon.image.withRenderingMode(.alwaysOriginal))
                        .resizable()
                        .frame(width: 26, height: 26)
                })
                .alert(isPresented: $viewModel.showingDeleteFeedAlert) {
                    Alert(
                        title: Text(L10n.Common.attention),
                        message: Text(L10n.DeleteFoundFeed.Alert.message),
                        primaryButton: .default(Text(L10n.Common.cancel)),
                        secondaryButton: .destructive(
                            Text(L10n.Common.proceed),
                            action: {
                                viewModel.deleteFeed(force: true)
                            }
                        ))
                }
            } else {
                Button(action: {
                    viewModel.saveFeed()
                }, label: {
                    Image(uiImage: Asset.plusIcon.image.withRenderingMode(.alwaysTemplate))
                        .resizable()
                        .frame(width: 26, height: 26)
                })
            }
        }
    }
}

struct FoundFeedView_Previews: PreviewProvider {
    static var previews: some View {
        FoundFeedView(feedTitle: "Test title", feedURLString: "https://foundfeedurl.xyz", tapHandler: {})
    }
}
