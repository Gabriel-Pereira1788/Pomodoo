import SwiftUI

class TimerSettingsViewModel: ObservableObject {
    @Published var uiState: TimerSettingsUIState = .settings
    @ObservedObject var timerDataStore = TimerDataStore.shared

    var selectedOption: TimerConfig = .focus(25)

    func changeUIState(to state: TimerSettingsUIState) {
        uiState = state
    }

    func redirectToChangeSettingsOption(_ option: TimerConfig) {
        selectedOption = option
        changeUIState(to: .changeOption)
    }

    func renderChangeSettingsOption() -> some View {

        let viewModel = ChangeSettingsOptionViewModel(option: selectedOption)

        return ChangeSettingsOptionView(
            goBack: {
                self.changeUIState(to: .settings)
            }, viewModel: viewModel)
    }
}
