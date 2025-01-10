import SwiftUI

struct TimerPopUpView: View {
    var redirectToSettingsView: () -> Void
    @ObservedObject var viewModel:TimerPopUpViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.renderUiState {
            case .timerPopUp:
                renderTimerPopUpContent()
            case .settings:
                viewModel.renderSettingsView()
            }
        }
        
    }
}

extension TimerPopUpView {
    func renderTimerPopUpContent() -> some View {
        VStack(alignment: .center,spacing: 15) {
            ZStack {
                renderTimer()
                renderTimerCircle()
            }
            
            HStack{
                Spacer(minLength: 85)
                Button(action:{
                    viewModel.uiState == .running ? viewModel.pause(): viewModel.start()
                }) {
                    Text(viewModel.uiState == .running ? "Pause" : "Start")
                        .padding(.vertical,10)
                        .padding(.horizontal,35)
                        .foregroundColor(.white)
                        .background(Color(.darkGray))
                        .clipShape(.capsule)
                }.buttonStyle(.plain)
                    .padding(.bottom,10)
                Spacer()
                ButtonAction( iconSystemName: "gear") {
                    viewModel.pause()
                    viewModel.changeRenderUiState(to: .settings)
                }
            }
            
            
        }
        .padding()
        .frame(width: 300, height:300)
    }
}

extension TimerPopUpView {
    
    func renderTimer() -> some View {
        VStack(alignment:.center,spacing:6) {
            Image(systemName: viewModel.uiState == .running ? "eye" : "cup.and.heat.waves")
                .font(.system(size: 20))
            
            Text(viewModel.timeString)
                .fontWeight(.medium)
                .font(.system(size: 50))
            
            renderSessionsCount()
            
            Text("FOCUS")
                .foregroundStyle(Color(.darkGray))
                .font(.caption2)
                .padding(.top,10)
        }
    }
    
    func renderTimerCircle() -> some View {
        Circle()
            .stroke(lineWidth: 7)
            .fill(Color(.darkGray))
            .frame(width: 200, height: 200)
            .onReceive(viewModel.$timeElapsed) {time in
                print(time)
            }
    }
    
    func renderSessionsCount() -> some View {
        HStack(spacing:10) {
            
            ForEach(0..<4, content: {index in
                Rectangle().frame(width: 3,height: 7)
                    .foregroundColor( viewModel.countSession > index ? .orange : Color(.darkGray))
                    .cornerRadius(10)
            })
        }
    }
}

#Preview {
    TimerPopUpView(redirectToSettingsView: {
        
    }, viewModel: TimerPopUpViewModel() )
}
