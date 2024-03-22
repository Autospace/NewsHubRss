import SwiftUI

struct AddFeedView: View {
    @FocusState private var textFieldIsFocused: Bool
    @StateObject var viewModel = AddFeedViewModel()

    var body: some View {
        VStack {
            VStack {
                Text(L10n.AddNewFeed.instruction)
                TextField(L10n.AddNewFeed.TextField.placeholder, text: $viewModel.feedUrlString)
                    .frame(height: 44)
                    .autocapitalization(.none)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.hasError ? Color.red : Color.gray)
                    )
                    .disableAutocorrection(true)
                    .focused($textFieldIsFocused)
                    .onChange(of: viewModel.feedUrlString) { _, _ in
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
                ForEach(viewModel.foundFeeds) { item in
                    FoundFeedView(feedTitle: item.title, feedURLString: item.link, tapHandler: {
                        viewModel.showingFeedEditView = true
                        viewModel.selectedItem = item
                    })
                }
            }
            .listStyle(.inset)
            .sheet(isPresented: $viewModel.showingFeedEditView, content: {
                if let selectedItem = viewModel.selectedItem {
                    EditFeedView(feed: selectedItem) { newTitle in
                        print(newTitle)
                    }
                }
            })
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
