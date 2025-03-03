import SwiftUI

struct DeviceDataView: View {
    @StateObject private var viewModel = DeviceViewModel()

    var body: some View {
        VStack {
            Text("Battery Level: \(viewModel.batteryLevel)")
                .font(.title2)
                .padding()

            Text("Device Time: \(viewModel.deviceTime)")
                .font(.title2)
                .padding()

            // ECG Waveform View
            if !viewModel.ecg.isEmpty {
                ECGWaveformView(ecgData: viewModel.ecg, lineColor: .green)
                    .frame(height: 200)
                    .padding()
            } else {
                Text("No ECG Data")
                    .foregroundColor(.gray)
                    .padding()
            }

            Button(action: {
                print("Fetch Data Button Pressed")
                viewModel.fetchData()
            }) {
                Text("Fetch Data")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            print("DeviceView appeared")
            viewModel.fetchData()
        }
    }
}
