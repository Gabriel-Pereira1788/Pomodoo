import SwiftUI

struct CircularProgressView: View {
    let progress:Double
    
    private let gradient = AngularGradient(
        gradient: Gradient(colors: [Color(.primay),Color(.primay),Color(.secondary), .white.opacity(0.0)]),
        center: .center,
        startAngle: .degrees(355),
        endAngle: .degrees(0))
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .fill(Color(.darkGray))
                
            Circle()
                .trim(from: 0, to: progress)
                .stroke(gradient, style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

#Preview {
    VStack {
        CircularProgressView(progress: 1)
    }.padding(20)
 
}
