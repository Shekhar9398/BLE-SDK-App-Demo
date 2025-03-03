import SwiftUI

struct ECGWaveformView: View {
    let ecgData: [Int] // Expect an array of Int, not ECGData
    let lineColor: Color
    let waveSpeed: Double = 0.05
    let spacingFactor: CGFloat = 3.0

    @State private var progress: CGFloat = 0
    @State private var offsetX: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height

                    guard !ecgData.isEmpty else { return }

                    let minVal = ecgData.min() ?? 0
                    let maxVal = ecgData.max() ?? 1
                    let range = maxVal - minVal
                    let scaleFactor = (height * 0.5) / CGFloat(range)
                    let stepX = (width / CGFloat(ecgData.count - 1)) * spacingFactor

                    let firstX: CGFloat = 0
                    let firstY = height / 2 - (CGFloat(ecgData[0] - minVal) * scaleFactor)
                    path.move(to: CGPoint(x: firstX, y: firstY))

                    for index in 1..<ecgData.count {
                        let x = CGFloat(index) * stepX
                        let y = height / 2 - (CGFloat(ecgData[index] - minVal) * scaleFactor)
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .trim(from: 0, to: progress)
                .stroke(lineColor, lineWidth: 2)
                .offset(x: offsetX, y: 0)
                .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: progress)
                .animation(.linear(duration: waveSpeed), value: offsetX)
                .onAppear {
                    progress = 1
                    Timer.scheduledTimer(withTimeInterval: waveSpeed, repeats: true) { _ in
                        offsetX -= 2
                    }
                }
            }
        }
        .frame(height: 200)
    }
}
