import SwiftUI

struct CommonTextFieldView: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 30))
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Spacer()
                    if !text.isEmpty {
                        Button {
                            self.text = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(.systemGray))
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
    }
}

#Preview {
    CommonTextFieldView(text: .constant("Test"), placeholder: "Test")
}
