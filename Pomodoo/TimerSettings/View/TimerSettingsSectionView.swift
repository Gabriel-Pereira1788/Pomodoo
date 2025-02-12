import SwiftUI

struct TimerSettingsSectionView<Content:View>:View {
    var title:String
    var content: () -> Content
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(title).font(.headline)
            VStack {
                content()
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(Color(.darkGray).opacity(0.3))
            .cornerRadius(5)
        }.frame(maxWidth: .infinity)
        
    }
}
