//import Foundation
//import CoreBluetooth
//
//class BatteryViewModel: NSObject, ObservableObject, BLEManagerDelegate {
//
//    static let shared = BatteryViewModel()
//
//    @Published var batteryLevel: String = "--"
//    
//    override private init() { // Prevent multiple instances
//        super.init()
//        BLEManager.shared.addDelegate(self) // ✅ Correctly add as a delegate
//    }
//    
//    deinit {
//        BLEManager.shared.removeDelegate(self) // ✅ Remove delegate when deallocated
//    }
//
//    func getBatteryLevel() {
//        guard let peripheral = BLEManager.shared.connectedPeripheral else {
//            print("No connected device")
//            return
//        }
//        
//        guard let sendChar = BLEManager.shared.discoveredCharacteristics[SEND_CHAR_UUID] else {
//            print("Send characteristic (FFF6) not found")
//            return
//        }
//
//        let batteryRequestData = BleSDK.sharedManager().getDeviceBatteryLevel()
//        
//        peripheral.writeValue(batteryRequestData as! Data, for: sendChar, type: .withResponse)
//    }
//    
//    // MARK: - BLEManagerDelegate Methods
//    func didReceiveData(peripheral: CBPeripheral, data: Data, from characteristic: CBCharacteristic) {
//        if characteristic.uuid == REC_CHAR_UUID {
//            let batteryValue = BleSDK.sharedManager().dataParsing(with: data)
//             
//             if let dicData = batteryValue?.dicData as? [String: Any],
//                let batteryLevelValue = dicData["batteryLevel"] {
//                 
//                 DispatchQueue.main.async {
//                     self.batteryLevel = "\(batteryLevelValue) %"
//                     print("Updated batteryLevel in ViewModel: \(self.batteryLevel)") // Debugging
//                 }
//
//                 print("Battery Level \(batteryLevelValue)%")
//             }
//        } else {
//            print("Received data from an unexpected characteristic")
//        }
//    }
//    
//    func didDiscover(peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {}
//    func didConnect(peripheral: CBPeripheral) {}
//    func didFailToConnect(peripheral: CBPeripheral, error: (any Error)?) {}
//    func didDisconnect(peripheral: CBPeripheral, error: (any Error)?) {}
//}
