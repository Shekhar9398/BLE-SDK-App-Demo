import Foundation

/// Enum representing various types of BLE data that can be fetched from the device.
enum BLEDataType: String {
    case deviceTime, batteryLevel, deviceVersion, macAddress, stepGoal, activityData
    case detailActivityData, sleepData, heartRate, spo2, temperature, gps
    case ecg, bloodPressure, hrv
}

/// A helper class responsible for fetching BLE data commands based on the given data type.
class BLEDataFetcher {
   
    static func getCommand(for type: BLEDataType, sdk: BleSDK) -> Data? {
        switch type {
        case .deviceTime:
            return sdk.getDeviceTime() as? Data
        case .batteryLevel:
            return sdk.getDeviceBatteryLevel() as? Data
        case .deviceVersion:
            return sdk.getDeviceInfo() as? Data
        case .macAddress:
            return sdk.getDeviceMacAddress() as? Data
        case .stepGoal:
            return sdk.getStepGoal() as? Data
        case .activityData:
            return sdk.getTotalActivityData(withMode: 0, withStart: nil) as? Data
        case .detailActivityData:
            return sdk.getDetailActivityData(withMode: 0, withStart: nil) as? Data
        case .sleepData:
            return sdk.getDetailSleepData(withMode: 0, withStart: nil) as? Data
        case .heartRate:
            return sdk.startDeviceMeasurement(withType: 1, isOpen: true, isPPG_Open: false, isPPI_Open: false) as? Data
        case .spo2:
            return sdk.startDeviceMeasurement(withType: 3, isOpen: true, isPPG_Open: true, isPPI_Open: false) as? Data
        case .temperature:
            return sdk.getTemperatureData(withMode: 0, withStart: nil) as? Data
        case .gps:
            return sdk.startDeviceMeasurement(withType: 4, isOpen: true, isPPG_Open: false, isPPI_Open: false) as? Data
        case .ecg:
            return sdk.startDeviceMeasurement(withType: 5, isOpen: true, isPPG_Open: true, isPPI_Open: true) as? Data
        case .bloodPressure:
            return sdk.startDeviceMeasurement(withType: 6, isOpen: true, isPPG_Open: false, isPPI_Open: false) as? Data
        case .hrv:
            return sdk.startDeviceMeasurement(withType: 7, isOpen: true, isPPG_Open: false, isPPI_Open: false) as? Data
        }
    }
}
