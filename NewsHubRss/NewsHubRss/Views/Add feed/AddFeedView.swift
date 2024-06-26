import SwiftUI

struct AddFeedView: View {
    @FocusState private var textFieldIsFocused: Bool
    @StateObject var viewModel = AddFeedViewModel()

    var body: some View {
        VStack {
            VStack {
                Text(L10n.AddNewFeed.instruction)
                TextField(L10n.AddNewFeed.TextField.placeholder, text: $viewModel.feedUrlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($textFieldIsFocused)
                    .onChange(of: viewModel.feedUrlString) { _ in
                        viewModel.hasError = false
                    }

                if viewModel.hasError {
                    Text(viewModel.errorText)
                        .listRowSeparator(.hidden)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(0)
                }

                Button {
                    viewModel.startScanningFeed()
                    textFieldIsFocused = false
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

            List {
                ForEach(viewModel.foundFeeds, id: \.link) { item in
                    FoundFeedView(feedTitle: item.title, feedURLString: item.link)
                }
            }
            .listStyle(.inset)
        }
        .navigationTitle(L10n.AddNewFeed.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddFeedView()
        }
    }
}
