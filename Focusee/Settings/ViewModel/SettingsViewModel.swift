import SwiftUI

class SettingsViewModel:ObservableObject {
    @Published var uiState:SettingsUIState = .settings
    @ObservedObject var timerDataStore = TimerDataStore.shared
    
    var selectedOption:TimerConfig = .focus(25)
    
    
    func changeUIState(to state:SettingsUIState) {
        uiState = state
    }
    
    func redirectToChangeSettingsOption(_ option:TimerConfig) {
        selectedOption = option
        changeUIState(to: .changeOption)
    }
    
    func renderChangeSettingsOption() -> some View {
        
        let viewModel = ChangeSettingsOptionViewModel(option: selectedOption)
        
        return ChangeSettingsOptionView(goBack:{
            self.changeUIState(to: .settings)
        },viewModel: viewModel)
    }
}
