import Foundation
import CoreBluetooth

class BLEScannerViewModel: NSObject, ObservableObject, BLEManagerDelegate {
    func didReceiveUpdatedData() {
        
    }
    
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var connectedDevice: CBPeripheral?
    @Published var isScanning: Bool = false
    @Published var bleManager = BLEManager.shared

    override init() {
        super.init()
        BLEManager.shared.delegate = self
    }

    func scanForDevices() {
        if !isScanning {
            discoveredDevices.removeAll()
            isScanning = true
            BLEManager.shared.startScanning()
        }
    }

    func stopScanning() {
        isScanning = false
        BLEManager.shared.stopScanning()
    }

    func connectToDevice(_ peripheral: CBPeripheral) {
        BLEManager.shared.connect(to: peripheral)
        DispatchQueue.main.async {
            self.connectedDevice = peripheral
        }
    }

    func disconnectDevice() {
        BLEManager.shared.disconnect()
        DispatchQueue.main.async {
            self.connectedDevice = nil
        }
    }

    func didUpdateDiscoveredDevices() {
        DispatchQueue.main.async {
            self.discoveredDevices = BLEManager.shared.discoveredDevices
        }
    }
}
