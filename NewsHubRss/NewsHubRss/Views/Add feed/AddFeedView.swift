import SwiftUI

struct AddFeedView: View {
    @StateObject var viewModel = AddFeedViewModel()

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if viewModel.hasError {
                        Text(viewModel.errorText)
                            .listRowSeparator(.hidden)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(0)
                    }

                    Button {
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
        .searchable(text: $viewModel.feedUrlString, prompt: "example.com")
        .keyboardType(.URL)
        .autocapitalization(.none)
        .autocorrectionDisabled()
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddFeedView(viewModel: AddFeedViewModel.getMockViewModel())
        }
    }
}
