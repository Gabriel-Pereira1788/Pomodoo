import SwiftUI

struct ButtonAction: View {

    var iconSystemName: String
    var iconSize: CGFloat = 40
    var backgroundColor: Color = Color(.darkGray).opacity(0.1)
    var action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                VStack {
                    Image(systemName: iconSystemName)
                        .font(.system(size: iconSize / 2))
                }.modifier(ButtonStyleV(iconSize: iconSize, backgroundColor: backgroundColor))
            }
        ).buttonStyle(.plain)

    }
}

struct ButtonStyleV: ViewModifier {
    var iconSize: CGFloat
    var backgroundColor: Color
    func body(content: Content) -> some View {
        content.frame(width: iconSize, height: iconSize)
            .font(Font.system(.title3).bold())
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(iconSize / 2)

    }
}
