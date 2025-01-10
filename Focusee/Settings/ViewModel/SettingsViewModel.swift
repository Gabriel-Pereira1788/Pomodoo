import SwiftUI

class SettingsViewModel:ObservableObject {
    
    @Published var uiState:SettingsUIState = .settings
    var selectedOption:SettingsOptions = .focus
    
    func changeUIState(to state:SettingsUIState) {
        uiState = state
    }
    
    func redirectToChangeSettingsOption(_ option:SettingsOptions) {
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
