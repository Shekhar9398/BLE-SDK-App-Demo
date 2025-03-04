import SwiftUI

struct DeviceTimeView: View {
    @ObservedObject var deviceViewModel: DeviceViewModel // Use shared ViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("⏰ Device Time")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(deviceViewModel.deviceTime)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.purple)

            Button(action: {
                print("Fetching Device Time...")
                deviceViewModel.fetchDeviceTime() // Fetch only device time
            }) {
                CustomButtonLabel(title: "🔄 Refresh", color: .purple)
            }
        }
        .padding()
        .onAppear {
            deviceViewModel.fetchDeviceTime() // Fetch when the view appears
        }
    }
}
