import Foundation
import CoreBluetooth

// Mark:- service and characteristic UUIDs
let SERVICE_UUID = CBUUID(string: "FFF0")
let SEND_CHAR_UUID = CBUUID(string: "FFF6")
let REC_CHAR_UUID = CBUUID(string: "FFF7")

protocol BLEManagerDelegate: AnyObject {
    func didUpdateDiscoveredDevices()
    func didReceiveUpdatedData()
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BLEManager()

    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var connectedDevice: CBPeripheral?
    @Published var bleModel = BLEModel()  // Stores all parsed data

    private var centralManager: CBCentralManager!
    private var sendCharacteristic: CBCharacteristic?
    private var recCharacteristic: CBCharacteristic?

    private let bleSDK = BleSDK.sharedManager()
    
    weak var delegate: BLEManagerDelegate?
    
    private var commandQueue: [BLEDataType] = [] // Queue for pending fetch requests

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    // MARK: - Scanning Methods
    func startScanning() {
        guard centralManager.state == .poweredOn else { return }
        if !centralManager.isScanning {
            discoveredDevices.removeAll()
            centralManager.scanForPeripherals(withServices: [SERVICE_UUID], options: nil)
        }
    }

    func stopScanning() {
        if centralManager.isScanning {
            centralManager.stopScan()
        }
    }

    // MARK: - Connection Methods
    func connect(to peripheral: CBPeripheral) {
        guard connectedDevice == nil else { return }
        stopScanning()
        peripheral.delegate = self
        connectedDevice = peripheral
        centralManager.connect(peripheral, options: nil)
    }

    func disconnect() {
        guard let peripheral = connectedDevice else { return }
        centralManager.cancelPeripheralConnection(peripheral)
        resetConnectionState()
    }

    private func resetConnectionState() {
        connectedDevice = nil
        sendCharacteristic = nil
        recCharacteristic = nil
        commandQueue.removeAll()
    }

    // MARK: - CBCentralManagerDelegate Methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn, connectedDevice == nil {
            startScanning()
        } else {
            stopScanning()
            disconnect()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        DispatchQueue.main.async {
            if !self.discoveredDevices.contains(where: { $0.identifier == peripheral.identifier }) {
                self.discoveredDevices.append(peripheral)
                self.delegate?.didUpdateDiscoveredDevices()
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown Device")")
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_UUID])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown Device")")
        resetConnectionState()
    }

    // MARK: - Handling Services and Characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            if service.uuid == SERVICE_UUID {
                peripheral.discoverCharacteristics([SEND_CHAR_UUID, REC_CHAR_UUID], for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics ?? [] {
            if characteristic.uuid == SEND_CHAR_UUID {
                sendCharacteristic = characteristic
                print("Send characteristic is writable")
                processPendingRequests()
            } else if characteristic.uuid == REC_CHAR_UUID {
                recCharacteristic = characteristic
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }

    // MARK: - Fetch Data
    func fetchData(for type: BLEDataType) {
        guard let _ = sendCharacteristic else {
            print("Send characteristic not available. Queuing request for \(type)")
            commandQueue.append(type)
            return
        }
        sendFetchCommand(for: type)
    }

    private func sendFetchCommand(for type: BLEDataType) {
        guard let commandData = getCommandData(for: type) else {
            print("No command data for \(type)")
            return
        }
        sendCommand(commandData, type: "\(type)")
    }

    private func getCommandData(for type: BLEDataType) -> Data? {
        switch type {
        case .deviceTime:
            return bleSDK?.getDeviceTime() as? Data
        case .batteryLevel:
            return bleSDK?.getDeviceBatteryLevel() as? Data
        case .deviceVersion:
            return bleSDK?.getDeviceInfo() as? Data
        case .macAddress:
            return bleSDK?.getDeviceMacAddress() as? Data
        case .stepGoal:
            return bleSDK?.getStepGoal() as? Data
        case .activityData:
            return bleSDK?.getTotalActivityData(withMode: 0, withStart: nil) as? Data
        case .detailActivityData:
            return bleSDK?.getDetailActivityData(withMode: 0, withStart: nil) as? Data
        case .sleepData:
            return bleSDK?.getDetailSleepData(withMode: 0, withStart: nil) as? Data
        case .heartRate:
            return bleSDK?.startDeviceMeasurement(withType: 1, isOpen: true, isPPG_Open: false, isPPI_Open: false) as? Data
        case .spo2:
            return bleSDK?.startDeviceMeasurement(withType: 3, isOpen: true, isPPG_Open: true, isPPI_Open: false) as? Data
        case .temperature:
            return bleSDK?.getTemperatureData(withMode: 0, withStart: nil) as? Data
        case .gps:
            return bleSDK?.startDeviceMeasurement(withType: 4, isOpen: true, isPPG_Open: false, isPPI_Open: false) as? Data
        case .ecg:
            return bleSDK?.startECGMode() as? Data
        case .bloodPressure:
            return bleSDK?.startDeviceMeasurement(withType: 2, isOpen: true, isPPG_Open: false, isPPI_Open: false) as? Data
        case .hrv:
            return bleSDK?.startDeviceMeasurement(withType: 5, isOpen: true, isPPG_Open: false, isPPI_Open: false) as? Data
        }
    }


    private func sendCommand(_ command: Data, type: String) {
        guard let peripheral = connectedDevice, let sendCharacteristic = sendCharacteristic else {
            print("Unable to send \(type), characteristic not ready")
            return
        }
        peripheral.writeValue(command, for: sendCharacteristic, type: .withResponse)
    }
    
    private func processPendingRequests() {
        while !commandQueue.isEmpty {
            let nextRequest = commandQueue.removeFirst()
            fetchData(for: nextRequest)
        }
    }
    
    // MARK: - Handling Incoming Data
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {
            print("No data received")
            return
        }

        print("Received Data: \(data.map { String(format: "%02X", $0) }.joined())")
        didReceiveData(peripheral: peripheral, data: data, from: characteristic)
    }

   private func didReceiveData(peripheral: CBPeripheral, data: Data, from characteristic: CBCharacteristic) {
        guard characteristic.uuid == REC_CHAR_UUID else {
            print("Received data from an unexpected characteristic")
            return
        }

        if let dataToParse = BleSDK.sharedManager().dataParsing(with: data),
           let parsedData = dataToParse.dicData as? [String: Any] {
            
            print("Parsed Data Before Updating BLEModel: \(parsedData)")  // Debugging line

            DispatchQueue.main.async {
                if let battery = parsedData["batteryLevel"] as? Int {
                    self.bleModel.batteryLevel = battery
                }
                if let time = parsedData["deviceTime"] as? String {
                    self.bleModel.deviceTime = time
                }
                self.bleModel.shouldUpdateView.toggle()
                
                print("BLEModel Updated: Battery: \(self.bleModel.batteryLevel ?? -1), Time: \(self.bleModel.deviceTime)") // Debugging line
            }
        } else {
            print("Failed to parse received data")
        }
    }

}
