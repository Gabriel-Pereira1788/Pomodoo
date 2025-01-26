import SwiftUI
struct ButtonAction:View {
    
    var iconSystemName:String
    var iconSize:CGFloat = 40
    var action:()->Void
    
    var body: some View {
        Button(action: action, label: {
            VStack {
                Image(systemName:iconSystemName)
                    .font(.system(size: iconSize / 2))
            }.modifier(ButtonStyleV(iconSize: iconSize))
        }).buttonStyle(.plain)
    }
}

struct ButtonStyleV: ViewModifier {
    var iconSize:CGFloat
    func body(content:Content) -> some View {
        content.frame(width:iconSize,height: iconSize)
            .font(Font.system(.title3).bold())
            .background(Color(.darkGray).opacity(0.1))
            .foregroundColor(.white)
            .cornerRadius(20.0)
            .overlay {
                
                Circle()
                    .stroke(lineWidth: 1)
                    .fill(Color(.darkGray))
                
            }
        
    }
}
