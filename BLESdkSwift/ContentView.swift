import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject private var viewModel = BLEScannerViewModel()
    @State private var navigateToDeviceData = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("BLE Device Scanner")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                if let device = viewModel.connectedDevice {
                    VStack {
                        Text("Connected to: \(device.name ?? "Unknown Device")")
                            .font(.headline)
                            .foregroundColor(.green)

                        NavigationLink(
                            destination: DeviceDataView(),
                            isActive: $navigateToDeviceData
                        ) {
                            EmptyView()
                        }
                        .hidden()

                        Button(action: {
                            print("Navigating to DeviceDataView...")
                            navigateToDeviceData = true
                        }) {
                            Text("View Device Data")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        Button("Disconnect") {
                            print("Disconnecting Device...")
                            viewModel.disconnectDevice()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }

                List(viewModel.discoveredDevices, id: \.identifier) { device in
                    HStack {
                        Text(device.name ?? "Unknown Device")
                        Spacer()
                        
                        if viewModel.connectedDevice == device {
                            Button("Disconnect") {
                                viewModel.disconnectDevice()
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.red)
                        } else {
                            Button("Connect") {
                                viewModel.connectToDevice(device)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }

                Button(viewModel.isScanning ? "Stop Scan" : "Scan for Devices") {
                    if viewModel.isScanning {
                        viewModel.stopScanning()
                    } else {
                        viewModel.scanForDevices()
                    }
                }
                .padding()
                .background(viewModel.isScanning ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("BLE Scanner")
        }
    }
}
