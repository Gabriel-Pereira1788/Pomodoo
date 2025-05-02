import Testing
import Foundation
@testable import Pomodoo

class SettingsOptionViewModelTest {
    private var viewModel:SettingsOptionViewModel!
    private var optionValue = 10
    init() {
        viewModel = SettingsOptionViewModel(
            option: .focus(optionValue),
            timerConfigNotifier: MockTimerConfigNotifier.shared
        )
    }
    
    @Test func testSettingsOption_WhenIncressValue() {
        viewModel.incressValue()
        
        #expect(viewModel.value > optionValue)
    }
    
    @Test func testSettingsOption_WhenDecreaseValue() {
        viewModel.decressValue()
        
        #expect(viewModel.value < optionValue)
    }
    
    @Test func testSettingsOption_WhenDecreaseValueWithMinValue() {
        
        viewModel = SettingsOptionViewModel(
            option: .focus(1),
            timerConfigNotifier: MockTimerConfigNotifier.shared
        )
        viewModel.decressValue()
        
        
        #expect(viewModel.value == 1)
    }
}
