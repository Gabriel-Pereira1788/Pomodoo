import SwiftUI
import Foundation

struct SettingsView: View {
    var goBack: () -> Void
    @ObservedObject var viewModel:SettingsViewModel
    var body: some View {
        ZStack {
            switch viewModel.uiState {
            case .settings:
                renderSettingsContent()
            case .changeOption:
                viewModel.renderChangeSettingsOption()
            }
        }
    }
}

extension SettingsView {
    
    func renderSettingsContent() -> some View {
        VStack {
            HStack {
                ButtonAction(action: goBack, iconSystemName: "chevron.left",iconSize: 35)
                
                Spacer()
                Text("Settings")
                    .fontWeight(.light)
                    .font(.title)
                Spacer(minLength: 90)
            }.frame(maxWidth:.infinity)
            
            
            VStack {
                
                ForEach(SettingsOptions.allCases,id:\.self) { option in
                    renderSettingsOption(title: option.title, time: option.value, timeLabel: option.label)
                }
                
            }
            Spacer()
        }.frame(maxWidth: 260,maxHeight: 200)
            .padding(.horizontal,30)
            .padding(.vertical,20)
        
    }
}

extension SettingsView {
    
    func renderSettingsOption(title:String,time:String,timeLabel:String) -> some View {
        Button(action:{viewModel.changeUIState(to: .changeOption)}) {
            HStack {
                Text(title)
                Spacer()
                HStack(alignment: .center) {
                    Text(time)
                        .fontWeight(.medium)
                        .font(.title2)
                    Text(timeLabel)
                        .foregroundStyle(Color(.darkGray))
                    Button(action:{}) {
                        Image(systemName:"chevron.right")
                            .font(.system(size: 20))
                            .foregroundStyle(Color(.darkGray))
                    }
                    .buttonStyle(.plain)
                }
                
            }.frame(maxWidth: .infinity)
                .padding(.vertical,3)
        }.buttonStyle(.plain)
        
    }
}


#Preview {
    SettingsView(goBack:{},viewModel: SettingsViewModel())
}
