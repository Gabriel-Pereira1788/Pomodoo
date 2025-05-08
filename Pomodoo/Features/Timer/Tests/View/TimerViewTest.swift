import SwiftUI
import ViewInspector
import XCTest

@testable import Pomodoo

extension TimerView: @retroactive Inspectable {

}

final class TimerViewTest: XCTestCase {
    private let viewModel: TimerViewModel = TimerViewModel(
        notificationService: MockNotificationService(),
        pomodoroEngine: PomodoroEngine(
            timerHandler: MockTimeHandler(), timerConfigNotifier: MockTimerConfigNotifier.shared
        )

    )

    private func renderTestTimerView() -> some View {
        let timerView = TimerView(
            viewModel: viewModel
        ).environmentObject(
            DataStore(
                timerConfigNotifier: MockTimerConfigNotifier.shared
            )
        )

        return timerView
    }

    private func getActiveCountSessions(_ timerView: some View) throws -> Int {
        let hstack = try timerView.inspect().find(ViewType.HStack.self) {
            try $0.accessibilityIdentifier() == "count_session_container"
        }
        var count = 0

        for index in 0..<hstack.count {
            let element = try hstack.find(viewWithId: "count_session_element_\(index)")
            let color = try element.foregroundColor()
            if color != Color(.darkGray) {
                count += 1
            }
        }
        return count
    }

    private func getButtonPlayIconName(_ timerView: some View) throws -> String {
        let playButtonIcon = try timerView.inspect().find(ViewType.Button.self) {
            try $0.accessibilityIdentifier() == "play_button"
        }
        let label = try playButtonIcon.labelView()
        let image = try label.zStack().image(0)
        let systemName = try image.actualImage().name()

        return systemName
    }

    private func getTimerContentInformations(_ timerView: some View) throws -> (
        timerIconName: String, timerCount: String, timerDesc: String
    ) {
        let timerContentContainer = try timerView.inspect().find(ViewType.VStack.self) {
            try $0.accessibilityIdentifier() == "timer_content_container"
        }

        let timerIcon = try timerContentContainer.image(0)
        let timerIconName = try timerIcon.actualImage().name()

        let texts = timerContentContainer.findAll(ViewType.Text.self)

        let timerCount = try texts.first?.string() ?? ""
        let timerDesc = try texts.last?.string() ?? ""

        return (
            timerIconName: timerIconName,
            timerCount: timerCount,
            timerDesc: timerDesc
        )
    }

    func testTimerView_WhenResetButtonPressed() throws {
        let timerView = renderTestTimerView()
        let resetButton = try timerView.inspect().find(ViewType.Button.self) {
            try $0.accessibilityIdentifier() == "reset_button"
        }

        //1) press reset button
        try resetButton.tap()

        //2) get button play icon name
        let buttonPlayIconName = try getButtonPlayIconName(timerView)

        //3) get active sessions count
        let activeCountSessions = try getActiveCountSessions(timerView)

        //4) get rendered timer content information
        let timerContent = try getTimerContentInformations(timerView)

        XCTAssertTrue(activeCountSessions == 0)
        XCTAssertEqual(buttonPlayIconName, "play")
        XCTAssertEqual(timerContent.timerIconName, "eye")
        XCTAssertEqual(timerContent.timerDesc, "Focus")
    }

}
