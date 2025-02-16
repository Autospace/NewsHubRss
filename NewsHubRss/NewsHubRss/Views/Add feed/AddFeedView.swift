import SwiftUI

struct AddFeedView: View {
    @StateObject var viewModel = AddFeedViewModel()
    @FocusState var isTextFieldFocused: Bool

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    CommonTextFieldView(
                        text: $viewModel.feedUrlString,
                        placeholder: "example.com",
                        isFocused: _isTextFieldFocused
                    )

                    if viewModel.hasError {
                        Text(viewModel.errorText)
                            .listRowSeparator(.hidden)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(0)
                    }

                    Button {
                        isTextFieldFocused = false
                        viewModel.startScanningFeed()
                    } label: {
                        HStack {
                            Spacer()
                            Text(L10n.AddNewFeed.scanButtonTitle)
                                .padding(4)
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.feedUrlString.count < 3 || viewModel.isLoading)
                    .listRowSeparator(.hidden)
                }
                .padding()

                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }

                ScrollView {
                    ForEach(viewModel.foundFeeds, id: \.link) { item in
                        GroupBox {
                            FoundFeedView(feedTitle: item.title, feedURLString: item.link)
                        }
                        .padding([.leading, .trailing], 8)
                    }
                }
            }
            .navigationTitle(L10n.AddNewFeed.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .keyboardType(.URL)
        .autocapitalization(.none)
        .autocorrectionDisabled()
    }
}

#Preview {
    AddFeedView(viewModel: AddFeedViewModel.getMockViewModel())
}
