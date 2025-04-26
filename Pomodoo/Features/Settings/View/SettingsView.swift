import SwiftUI
import Foundation

struct SettingsView: View {
    var goBack: () -> Void
    @StateObject var viewModel:SettingsViewModel
    @EnvironmentObject var dataStore:DataStore
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
            HStack(alignment:.center) {
                Image(systemName: "gear").font(.largeTitle)
                    .foregroundStyle(Color(.darkGray))
            }.frame(maxWidth:.infinity)
            
            VStack(spacing:20) {
                SectionView(title: "Colors"){
                    VStack {
                        renderColorPicker(label: "Primary Color", selection: $dataStore.primaryColor)
                        renderColorPicker(label: "Secondary Color", selection: $dataStore.secondaryColor)
                    }
                    
                }
                
                SectionView(title:"Intervals") {
                    VStack{
                        renderSettingsOption(option: .focus(dataStore.focusValue))
                        renderSettingsOption(option: .longBreak(dataStore.longBreakValue))
                        renderSettingsOption(option: .shortBreak(dataStore.shortBreakValue))
                        renderSettingsOption(option: .sessions(dataStore.sessionsLimitValue))
                    }
                }
            }
        }.frame(maxWidth: 260)
            .padding(.horizontal,30)
            .padding(.vertical,40)
    }
}

extension SettingsView {
    func renderColorPicker(label:String,selection:Binding<Color>) -> some View {
        HStack {
            Text(label).font(.subheadline)
            Spacer()
            ColorPicker("",
                        selection: selection
            )
        }.frame(maxWidth: .infinity)
            .padding(.vertical,3)
    }
    
    func renderSettingsOption(option:TimerConfig) -> some View {
        Button(action:{viewModel.redirectToChangeSettingsOption(option)}) {
            
            HStack {
                Text(option.title)
                    .font(.subheadline)
                Spacer()
                HStack(alignment: .center) {
                    Text(option.value)
                        .fontWeight(.medium)
                        .font(.title2)
                    Text(option.label)
                        .foregroundStyle(Color(.gray))
                    Button(action:{}) {
                        Image(systemName:"chevron.right")
                            .font(.system(size: 15))
                            .foregroundStyle(Color(.gray))
                    }
                    .buttonStyle(.plain)
                }
                
            }.frame(maxWidth: .infinity)
                .padding(.vertical,3)
        }.buttonStyle(.plain)
        
    }
}

#Preview {
    SettingsView(goBack:{},viewModel: SettingsViewModel(
        timerConfigNotifier: TimerConfigNotifier.shared
    ))
}
