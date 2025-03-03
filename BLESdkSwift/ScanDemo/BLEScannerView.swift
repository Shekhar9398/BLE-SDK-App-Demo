import SwiftUI
import CoreBluetooth

struct BLEScannerView: View {
    @ObservedObject var scannerViewModel: BLEScannerViewModel

    var body: some View {
        VStack {
            Text("Discovered BLE Devices")
                .font(.headline)
                .padding()

            List(scannerViewModel.discoveredDevices, id: \.identifier) { device in
                HStack {
                    Text(device.name ?? "Unknown Device")
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
            }

            Button(scannerViewModel.isScanning ? "Stop Scan" : "Scan for Devices") {
                scannerViewModel.scanForDevices()
            }
            .padding()
            .background(scannerViewModel.isScanning ? Color.red : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
