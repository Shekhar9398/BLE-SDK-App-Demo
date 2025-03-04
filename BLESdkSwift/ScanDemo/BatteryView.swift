import SwiftUI

struct BatteryView: View {
    @ObservedObject var deviceViewModel: DeviceViewModel // Use shared ViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("🔋 Battery Level")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("\(deviceViewModel.batteryLevel)")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.green)

            Button(action: {
                print("Fetching Battery Data...")
                deviceViewModel.fetchBatteryLevel() // Fetch only battery data
            }) {
                CustomButtonLabel(title: "🔄 Refresh", color: .blue)
            }
        }
        .padding()
        .onAppear {
            deviceViewModel.fetchBatteryLevel() // Fetch when the view appears
        }
    }
}
