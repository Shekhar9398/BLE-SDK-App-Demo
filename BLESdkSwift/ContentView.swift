import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject private var scannerViewModel = BLEScannerViewModel()
    @State private var navigateToBattery = false
    @State private var navigateToDeviceTime = false
    @State private var navigateToECG = false

    private let deviceViewModel = DeviceViewModel() // Shared across views

    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text("🔵 BLE Device Scanner")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 30)

                    if let device = scannerViewModel.connectedDevice {
                        VStack(spacing: 15) {
                            Text("Connected to: **\(device.name ?? "Unknown Device")**")
                                .font(.headline)
                                .foregroundColor(.green)

                            // Navigation Links with Data Fetching
                            NavigationLink(destination: BatteryView(deviceViewModel: deviceViewModel),
                                           isActive: $navigateToBattery) { EmptyView() }
                            NavigationLink(destination: DeviceTimeView(deviceViewModel: deviceViewModel),
                                           isActive: $navigateToDeviceTime) { EmptyView() }
                            NavigationLink(destination: ECGView(deviceViewModel: deviceViewModel),
                                           isActive: $navigateToECG) { EmptyView() }

                            Button(action: {
                                deviceViewModel.fetchBatteryLevel()
                                navigateToBattery = true
                            }) {
                                CustomButtonLabel(title: "🔋 Battery Level", color: .blue)
                            }

                            Button(action: {
                                deviceViewModel.fetchDeviceTime()
                                navigateToDeviceTime = true
                            }) {
                                CustomButtonLabel(title: "⏰ Device Time", color: .purple)
                            }

                            Button(action: {
                                deviceViewModel.fetchECGData()
                                navigateToECG = true
                            }) {
                                CustomButtonLabel(title: "📊 ECG Data", color: .green)
                            }

                            Button(action: {
                                scannerViewModel.disconnectDevice()
                            }) {
                                CustomButtonLabel(title: "❌ Disconnect", color: .red)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // List of Discovered BLE Devices
                    List(scannerViewModel.discoveredDevices, id: \.identifier) { device in
                        HStack {
                            Text(device.name ?? "Unknown Device")
                                .foregroundColor(.white)
                            Spacer()
                            if scannerViewModel.connectedDevice == device {
                                Button("Disconnect") {
                                    scannerViewModel.disconnectDevice()
                                }
                                .buttonStyle(.bordered)
                                .foregroundColor(.red)
                            } else {
                                Button("Connect") {
                                    scannerViewModel.connectToDevice(device)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .listRowBackground(Color.gray.opacity(0.3))
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.black)

                    // Start/Stop Scan Button
                    Button(action: {
                        if scannerViewModel.isScanning {
                            scannerViewModel.stopScanning()
                        } else {
                            scannerViewModel.scanForDevices()
                        }
                    }) {
                        CustomButtonLabel(
                            title: scannerViewModel.isScanning ? "🛑 Stop Scan" : "🔍 Scan for Devices",
                            color: scannerViewModel.isScanning ? .red : .blue
                        )
                    }
                }
                .padding()
            }
        }
    }
}

struct CustomButtonLabel: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .font(.headline)
            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 5)
    }
}
