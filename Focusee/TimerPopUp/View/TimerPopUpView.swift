import SwiftUI

struct TimerPopUpView: View {
    @ObservedObject var viewModel: TimerPopUpViewModel
    
    @Environment(\.openSettings) private var openSettings
    var body: some View {
        ZStack {
            renderTimerPopUpContent()
        }
        
    }
}

extension TimerPopUpView {
    func renderTimerPopUpContent() -> some View {
        VStack(alignment: .center, spacing: 15) {
            ZStack {
                renderTimer()
                CircularProgressView(progress: viewModel.progress,colors:
                                        [viewModel.timerDataStore.primaryColor,
                                         viewModel.timerDataStore.primaryColor,
                                         viewModel.timerDataStore.secondaryColor,
                                         .white.opacity(0.0)])
            }
            
            HStack {
                Spacer(minLength: 85)
                Button(action: {
                    viewModel.uiState == .paused ? viewModel.start() : viewModel.pause()
                }) {
                    Text(viewModel.uiState == .paused ? "Start" : "Pause")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 35)
                        .foregroundColor(.white)
                        .background(Color(.darkGray))
                        .clipShape(.capsule)
                }.buttonStyle(.plain)
                    .padding(.bottom, 10)
                Spacer()
                ButtonAction(iconSystemName: "gear") {
                    openSettings()
                }
            }
            
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}

extension TimerPopUpView {
    
    func renderTimer() -> some View {
        VStack(alignment: .center, spacing: 6) {
            Image(systemName: viewModel.timerBreak == .focus ? "eye" : "cup.and.heat.waves")
                .font(.system(size: 20))
            
            Text(viewModel.timeString)
                .fontWeight(.medium)
                .font(.system(size: 50))
            
            renderSessionsCount()
            
            Text(viewModel.timerBreak.description)
                .foregroundStyle(Color(.darkGray))
                .font(.caption2)
                .padding(.top, 10)
        }
    }
    
    func renderSessionsCount() -> some View {
        HStack(spacing: 10) {
            ForEach(0..<viewModel.timerDataStore.sessionsLimitValue, id: \.self) { index in
                Rectangle().frame(width: 3, height: 7)
                    .foregroundColor(viewModel.countSession > index ? viewModel.timerDataStore.primaryColor : Color(.darkGray))
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    TimerPopUpView(
        viewModel: TimerPopUpViewModel())
}
