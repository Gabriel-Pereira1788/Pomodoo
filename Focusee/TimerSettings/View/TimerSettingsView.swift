import SwiftUI
import Foundation

struct TimerSettingsView: View {
    var goBack: () -> Void
    @StateObject var viewModel:TimerSettingsViewModel
    
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

extension TimerSettingsView {
    
    func renderSettingsContent() -> some View {
        VStack {
            HStack(alignment:.center) {
                Image(systemName: "gear").font(.largeTitle)
                    .foregroundStyle(Color(.darkGray))
            }.frame(maxWidth:.infinity)
            
            VStack(spacing:20) {
                TimerSettingsSectionView(title: "Colors"){
                    VStack {
                        renderColorPicker(label: "Primary Color", selection: $viewModel.timerDataStore.primaryColor)
                        renderColorPicker(label: "Secondary Color", selection: $viewModel.timerDataStore.secondaryColor)
                    }
                    
                }
                
                TimerSettingsSectionView(title:"Intervals") {
                    VStack{
                        renderSettingsOption(option: .focus(viewModel.timerDataStore.focusValue))
                        renderSettingsOption(option: .longBreak(viewModel.timerDataStore.longBreakValue))
                        renderSettingsOption(option: .shortBreak(viewModel.timerDataStore.shortBreakValue))
                        renderSettingsOption(option: .sessions(viewModel.timerDataStore.sessionsLimitValue))
                    }
                }
            }
        }.frame(maxWidth: 260)
            .padding(.horizontal,30)
            .padding(.vertical,40)
    }
}

extension TimerSettingsView {
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
                            .font(.system(size: 20))
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
    TimerSettingsView(goBack:{},viewModel: TimerSettingsViewModel())
}
