import SwiftUI

struct AddFeedView: View {
    @StateObject var viewModel = AddFeedViewModel()

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    TextField("example.com", text: $viewModel.feedUrlString)
                        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 30))
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Spacer()
                                if !viewModel.feedUrlString.isEmpty {
                                    Button {
                                        self.viewModel.feedUrlString = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(Color(.systemGray))
                                            .padding(.trailing, 8)
                                    }
                                }
                            }
                        )

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
