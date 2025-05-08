import Combine
import Foundation
import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var uiState: TimerUIState = .paused
    @Published var progress: Double = 0.0
    @ObservedObject var pomodoroEngine: PomodoroEngine
    
    private var notificationService: NotificationServiceProtocol
    private var openPopover: () -> Void = {}
    private var cancellables: [AnyCancellable] = []
    
    var intervals: [TimerBreak: TimeInterval] = [:]
    
    var timeString: String {
        let minutes = Int(pomodoroEngine.elapsedTime) / 60
        let seconds = Int(pomodoroEngine.elapsedTime) % 60
        let value = String(format: "%02d:%02d", minutes, seconds)
        
        return value
    }
    
    init(
        notificationService: NotificationServiceProtocol, pomodoroEngine: PomodoroEngine
    ) {
        self.pomodoroEngine = pomodoroEngine
        self.notificationService = notificationService
        notificationService.checkNotificationPermission()
        
        self.pomodoroEngine.$elapsedTime.sink {
            [weak self] elapsed in
            guard let self else { return }
            
            let initialTime = pomodoroEngine.getInitialTime()
            self.progress = initialTime > 0 ? Double(elapsed) / Double(initialTime) : 0.0
        }
        .store(in: &cancellables)
        
        self.pomodoroEngine.$phase.sink { phase in
            self.handleCycleTransition(from: phase)
        }.store(in: &cancellables)
        
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    func setOpenPopoverFunc(_ callback: @escaping () -> Void) {
        openPopover = callback
    }
    
    func setDataStore(_ dataStore: DataStore) {
        self.pomodoroEngine.setDataStore(dataStore)
    }
    
    
}

extension TimerViewModel {
    func start() {
        guard uiState == .paused else { return }
        
        uiState = .running
        pomodoroEngine.start()
    }
    
    func pause() {
        uiState = .paused
        pomodoroEngine.stop()
    }
    
    func onReset() {
        uiState = .paused
        pomodoroEngine.reset()
        pomodoroEngine.changeTimerPhase(to: .focus)
    }
    
    func prevPhase() {
        pomodoroEngine.prev {
            self.uiState = .paused
        }
    }
    
    func nextPhase() {
        pomodoroEngine.next()
        uiState = .paused
        openPopover()
    }
    
    private func handleCycleTransition(from breakType: TimerBreak) {
        
        let notificationContent = TimerNotificationData.getNotificationContent(for: breakType)
        
        scheduleNotification(notificationContent: notificationContent)
    }
    
    private func scheduleNotification(notificationContent: TimerNotificationContent) {
        notificationService.scheduleNotification(
            title: notificationContent.title, body: notificationContent.body, timeInterval: 0.1)
    }
    
}
