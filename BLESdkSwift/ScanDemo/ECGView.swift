import SwiftUI

struct ECGView: View {
    @ObservedObject var deviceViewModel: DeviceViewModel
    @State private var ecgData: [CGFloat] = []

    let maxVisiblePoints = 2000  // Display full ECG wave over 30 sec
    let amplitude: CGFloat = 200  // Scaling for visualization

    var body: some View {
        VStack {
            Text("💓 ECG Live View")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Canvas { context, size in
                guard ecgData.count > 1 else { return }

                var path = Path()
                let stepX = size.width / CGFloat(maxVisiblePoints)
                let midY = size.height / 2

                let minValue = ecgData.min() ?? 0
                let maxValue = ecgData.max() ?? 1
                let range = maxValue - minValue
                let scaleFactor = range == 0 ? 1 : min(amplitude / range, size.height / 2)

                path.move(to: CGPoint(x: 0, y: midY - (ecgData[0] - minValue) * scaleFactor))

                for i in 1..<ecgData.count {
                    let x = CGFloat(i) * stepX
                    let y = midY - (ecgData[i] - minValue) * scaleFactor
                    path.addLine(to: CGPoint(x: x, y: y))
                }

                context.stroke(path, with: .color(.green), lineWidth: 2)
            }
            .frame(height: 250)
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .padding()

            Button("🔄 Refresh ECG") {
                updateECG(deviceViewModel.ecg)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onReceive(deviceViewModel.$ecg
            .throttle(for: .milliseconds(50), scheduler: DispatchQueue.main, latest: true)
            .removeDuplicates()
        ) { newECG in
            updateECG(newECG)
        }
    }

    private func updateECG(_ newECG: [Int]) {
        DispatchQueue.main.async {
            guard !newECG.isEmpty else { return }

            let minValue = newECG.min() ?? 0
            let maxValue = newECG.max() ?? 1
            let range = maxValue - minValue

            // Normalize dynamically
            ecgData = newECG.map { CGFloat($0 - minValue) / CGFloat(range == 0 ? 1 : range) * amplitude }

            // Keep only last `maxVisiblePoints` values
            if ecgData.count > maxVisiblePoints {
                ecgData = Array(ecgData.suffix(maxVisiblePoints))
            }
        }
    }
}
