import SwiftUI

struct TimerView: View {
    
    @ObservedObject var viewModel: TimerViewModel
    
    @EnvironmentObject var dataStore:DataStore
    @Environment(\.openSettings) private var openSettings
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                HStack {
                    ButtonAction(
                        iconSystemName:"arrow.trianglehead.clockwise",
                        accessibilityID: "reset_button"
                    ){
                        viewModel.onReset()
                    }
                    
                    Spacer()
                    ButtonAction(iconSystemName: "gear",accessibilityID: "settings_button") {
                        openSettings()
                    }
                }
                ZStack {
                    renderTimer()
                    CircularProgressView(
                        progress: viewModel.progress,
                        colors: [
                            dataStore.primaryColor,
                            dataStore.primaryColor,
                            dataStore.secondaryColor,
                            .white.opacity(0.0),
                        ])
                }
                
                HStack {
                    Spacer()
                    HStack(spacing: 10) {
                        ButtonAction(iconSystemName: "chevron.left", iconSize: 30,accessibilityID: "prev_button") {
                            viewModel.prevPhase()
                        }
                        ButtonAction(
                            iconSystemName: viewModel.uiState == .paused ? "play" : "pause",
                            iconSize: 50,
                            backgroundColor: dataStore.primaryColor,
                            accessibilityID: "play_button"
                        ) {
                            viewModel.uiState == .paused ? viewModel.start() : viewModel.pause()
                        }
                        ButtonAction(iconSystemName: "chevron.right", iconSize: 30,accessibilityID: "next_button") {
                            viewModel.nextPhase()
                        }
                    }
                    Spacer()
                }
                
            }
            .padding()
            .frame(width: 300, height: 350)
        }.onAppear(){
            viewModel.setDataStore(dataStore)
        }
        
    }
}

extension TimerView {
    
    func renderTimer() -> some View {
        VStack(alignment: .center, spacing: 6) {
            Image(systemName: viewModel.pomodoroEngine.phase == .focus ? "eye" : "cup.and.heat.waves")
                .font(.system(size: 20))
            
            Text(viewModel.timeString)
                .fontWeight(.medium)
                .font(.system(size: 50))
            
            renderSessionsCount()
            
            Text(viewModel.pomodoroEngine.phase.description)
                .foregroundStyle(Color(.darkGray))
                .font(.caption2)
                .padding(.top, 10)

        }.accessibilityIdentifier("timer_content_container")
    }
    
    func renderSessionsCount() -> some View {
        HStack(spacing: 10) {
            ForEach(0..<dataStore.sessionsLimitValue, id: \.self) { index in
                Rectangle().frame(width: 3, height: 7)
                    .foregroundColor(
                        viewModel.pomodoroEngine.countSession > index
                        ? dataStore.primaryColor : Color(.darkGray)
                    )
                    .cornerRadius(10)
                    .id("count_session_element_\(index)")
            }
        }.accessibilityIdentifier("count_session_container")
    }
}

#Preview {
    TimerView(
        viewModel: TimerViewModel(
            notificationService: NotificationService.shared,
            pomodoroEngine: PomodoroEngine(
                timerHandler: TimerHandler(),
                timerConfigNotifier: TimerConfigNotifier.shared
            )
            
        )
    )
    
}
