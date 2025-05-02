import Testing
import Foundation
@testable import Pomodoo

class SettingsViewModelTest {
    private var viewModel:SettingsViewModel!
    
    init() {
        viewModel = SettingsViewModel(
            timerConfigNotifier: MockTimerConfigNotifier.shared
        )
    }
    
    @Test func testSettings_WhenChangeUIState() {
        viewModel.changeUIState(to: .changeOption)
        
        #expect(viewModel.uiState == .changeOption)
    }
    
    @Test func testSettings_WhenRedirectToChangeOptionScreen() {
        viewModel.redirectToChangeSettingsOption(.focus(10))
        
        #expect(viewModel.uiState == .changeOption)
    }
    
    @Test func testSettings_WhenRenderChangeSettingsOption() {
        viewModel.redirectToChangeSettingsOption(.focus(10))
        let settingsOptionView = viewModel.renderChangeSettingsOption()
        
        #expect(settingsOptionView != nil)
    }
}
