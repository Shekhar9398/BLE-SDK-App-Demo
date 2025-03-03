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

            Button(action: {
                print("🔘 Fetch Data Button Pressed")
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
