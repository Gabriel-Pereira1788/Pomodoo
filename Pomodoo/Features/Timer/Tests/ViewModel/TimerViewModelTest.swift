import Testing
import Foundation
@testable import Pomodoo

class TimerViewModelTest {
    private var viewModel: TimerViewModel!
    private var timerHandlerMock: MockTimeHandler!
    private var notificationServiceMock:MockNotificationService!
    init() {
        timerHandlerMock = MockTimeHandler()
        notificationServiceMock = MockNotificationService()
        viewModel = TimerViewModel(timerConfigNotifier:MockTimerConfigNotifier.shared,
                                   notificationService:notificationServiceMock,
                                   timerHandler: timerHandlerMock

        )
        viewModel.setDataStore(DataStore(
            timerConfigNotifier: MockTimerConfigNotifier.shared
        ))
        
    }
    
    @Test func testTimerTrigger_WhenPauseActionRun() {
        viewModel.pause()
        #expect(viewModel.uiState == .paused)
    }
    
    @Test func testTimerTrigger_WhenDecreaseEleapsedTime() async throws {
        viewModel.start()
        
        let initialElapsedTime = viewModel.elapsedTime
        timerHandlerMock.trigger()
        
        #expect(viewModel.uiState == .running)
        #expect(viewModel.elapsedTime < initialElapsedTime)
    }
    
    @Test func testTimerTrigger_WhenDispatchNotification() {
        viewModel.start()
        viewModel.elapsedTime = 1
        
        timerHandlerMock.trigger()
        let notificationData = TimerNotificationData.getNotificationContent(for: .short)
        let scheduleNotificationContent = notificationServiceMock.getScheduleNotificationContent()
        
        #expect(notificationData.body == scheduleNotificationContent?.body)
        #expect(notificationData.title == scheduleNotificationContent?.title)
    }
    
    @Test func testTimerTrigger_WhenChangeToShortBreakPhase() {
        viewModel.start()
        viewModel.elapsedTime = 1
        
        timerHandlerMock.trigger()
        
        #expect(viewModel.timerBreak == .short)
    }
    
    @Test func testTimerTrigger_WhenChangeToFocusPhase() {
        viewModel.start()
        viewModel.elapsedTime = 1
        viewModel.timerBreak = .short
        
        timerHandlerMock.trigger()
        
        #expect(viewModel.timerBreak == .focus)
    }
    
    @Test func testTimerTrigger_WhenChangeToLongBreakPhase() {
        viewModel.start()
        viewModel.elapsedTime = 1
        viewModel.timerBreak = .short
        viewModel.countSession = 5
        
        timerHandlerMock.trigger()
        
        #expect(viewModel.timerBreak == .long)
        #expect(viewModel.countSession == 0)
    }
    
    @Test func testTimerTrigger_WhenResetTimer() {
        viewModel.onReset()
        
        #expect(viewModel.countSession == 0)
        #expect(viewModel.uiState == .paused)
        #expect(viewModel.timerBreak == .focus)
    }
    
    @Test func testTimerTrigger_WhenPrevActionRunToFocusPhase() {
        viewModel.countSession = 2
        viewModel.timerBreak = .short
        
        viewModel.prevPhase()
        
        #expect(viewModel.countSession == 1)
        #expect(viewModel.timerBreak == .focus)
    }
    
    @Test func testTimerTrigger_WhenPrevActionRunToShortBreakPhase() {
        viewModel.countSession = 1
        viewModel.timerBreak = .focus
        
        viewModel.prevPhase()
        
        #expect(viewModel.timerBreak == .short)
    }
}
