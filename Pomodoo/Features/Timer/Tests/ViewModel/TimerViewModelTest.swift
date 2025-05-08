import Foundation
import Testing

@testable import Pomodoo

class TimerViewModelTest {
    private var viewModel: TimerViewModel!
    private var timerHandlerMock: MockTimeHandler!
    private var notificationServiceMock: MockNotificationService!
    init() {
        timerHandlerMock = MockTimeHandler()
        notificationServiceMock = MockNotificationService()
        viewModel = TimerViewModel(
            notificationService: notificationServiceMock,
            pomodoroEngine: PomodoroEngine(
                timerHandler: timerHandlerMock,
                timerConfigNotifier: MockTimerConfigNotifier.shared
            )

        )
        viewModel.setDataStore(
            DataStore(
                timerConfigNotifier: MockTimerConfigNotifier.shared
            ))

    }

    @Test func testTimerTrigger_WhenPauseActionRun() {
        viewModel.pause()
        #expect(viewModel.uiState == .paused)
    }

    @Test func testTimerTrigger_WhenDecreaseEleapsedTime() {
        viewModel.start()

        let initialElapsedTime = viewModel.pomodoroEngine.elapsedTime
        timerHandlerMock.trigger()

        #expect(viewModel.uiState == .running)
        #expect(viewModel.pomodoroEngine.elapsedTime < initialElapsedTime)
    }

    @Test func testTimerTrigger_WhenDispatchNotification() {
        viewModel.start()
        viewModel.pomodoroEngine.elapsedTime = 1

        timerHandlerMock.trigger()
        let notificationData = TimerNotificationData.getNotificationContent(for: .short)
        let scheduleNotificationContent = notificationServiceMock.getScheduleNotificationContent()

        #expect(notificationData.body == scheduleNotificationContent?.body)
        #expect(notificationData.title == scheduleNotificationContent?.title)
    }

    @Test func testTimerTrigger_WhenChangeToShortBreakPhase() {
        viewModel.start()
        viewModel.pomodoroEngine.elapsedTime = 1

        timerHandlerMock.trigger()

        #expect(viewModel.pomodoroEngine.phase == .short)
    }

    @Test func testTimerTrigger_WhenChangeToFocusPhase() {
        viewModel.start()
        viewModel.pomodoroEngine.elapsedTime = 1
        viewModel.pomodoroEngine.phase = .short

        timerHandlerMock.trigger()

        #expect(viewModel.pomodoroEngine.phase == .focus)
    }

    @Test func testTimerTrigger_WhenChangeToLongBreakPhase() {
        viewModel.start()
        viewModel.pomodoroEngine.elapsedTime = 1
        viewModel.pomodoroEngine.phase = .short
        viewModel.pomodoroEngine.countSession = 5

        timerHandlerMock.trigger()

        #expect(viewModel.pomodoroEngine.phase == .long)
        #expect(viewModel.pomodoroEngine.countSession == 0)
    }

    @Test func testTimerTrigger_WhenResetTimer() {
        viewModel.onReset()

        #expect(viewModel.pomodoroEngine.countSession == 0)
        #expect(viewModel.uiState == .paused)
        #expect(viewModel.pomodoroEngine.phase == .focus)
    }

    @Test func testTimerTrigger_WhenPrevActionRunToFocusPhase() {
        viewModel.pomodoroEngine.countSession = 2
        viewModel.pomodoroEngine.phase = .short

        viewModel.prevPhase()

        #expect(viewModel.pomodoroEngine.countSession == 1)
        #expect(viewModel.pomodoroEngine.phase == .focus)
    }

    @Test func testTimerTrigger_WhenPrevActionRunToShortBreakPhase() {
        viewModel.pomodoroEngine.countSession = 1
        viewModel.pomodoroEngine.phase = .focus

        viewModel.prevPhase()

        #expect(viewModel.pomodoroEngine.phase == .short)
    }
}
