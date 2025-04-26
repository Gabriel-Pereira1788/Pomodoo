import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var uiState: SettingsUIState = .settings
    private var timerConfigNotifier:TimerConfigNotifierProtocol
    private var settingsOptionViewModel:SettingsOptionViewModel!
    
    init(timerConfigNotifier:TimerConfigNotifierProtocol){
        self.timerConfigNotifier = timerConfigNotifier
    }

    func changeUIState(to state: SettingsUIState) {
        uiState = state
    }

    func redirectToChangeSettingsOption(_ option: TimerConfig) {
        self.settingsOptionViewModel =  SettingsOptionViewModel(option: option,timerConfigNotifier: TimerConfigNotifier.shared)
        changeUIState(to: .changeOption)
    }

    func renderChangeSettingsOption() -> some View {

        return SettingsOptionView(
            goBack: {
                self.changeUIState(to: .settings)
            }, viewModel: settingsOptionViewModel)
    }
}
