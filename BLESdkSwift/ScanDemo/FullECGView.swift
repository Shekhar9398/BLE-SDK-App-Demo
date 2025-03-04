import SwiftUI

struct FullECGView: View {
    let fullWaveData: [CGFloat]

    var body: some View {
        VStack {
            Text("📈 Full ECG Waveform")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Canvas { context, size in
                guard fullWaveData.count > 1 else { return }

                var path = Path()
                let stepX = size.width / CGFloat(fullWaveData.count)
                let midY = size.height / 2

                let minValue = fullWaveData.min() ?? 0
                let maxValue = fullWaveData.max() ?? 1
                let scaleFactor = min(200 / (maxValue - minValue), size.height / 2)

                path.move(to: CGPoint(x: 0, y: midY - (fullWaveData[0] - minValue) * scaleFactor))

                for i in 1..<fullWaveData.count {
                    let x = CGFloat(i) * stepX
                    let y = midY - (fullWaveData[i] - minValue) * scaleFactor
                    path.addLine(to: CGPoint(x: x, y: y))
                }

                context.stroke(path, with: .color(.green), lineWidth: 2)
            }
            .frame(height: 400)
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .padding()

            Button("Close") {
                // Dismiss View
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.first?.rootViewController?.dismiss(animated: true)
                }
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
