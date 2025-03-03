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
            ///Mark:- Direct data
        case .deviceTime:
            return sdk.getDeviceTime() as Data
        case .batteryLevel:
            return sdk.getDeviceBatteryLevel() as Data
        case .deviceVersion:
            return sdk.getDeviceVersion() as Data
        case .macAddress:
            return sdk.getDeviceMacAddress() as Data
        case .stepGoal:
            return sdk.getStepGoal() as Data
        case .ecg:
            return sdk.startECGMode() as Data
            
            ///Mark:- Activity Data
        case .activityData:
            return sdk.getTotalActivityData(withMode: 0, withStart: Date()) as Data?
        case .detailActivityData:
            return sdk.getTotalActivityData(withMode: 0, withStart: Date()) as Data?
        case .sleepData:
            return sdk.getDetailSleepData(withMode: 0, withStart: Date()) as Data?
            
            ///Mark: Live data HRV, Heart Rate and SPO2
        case .hrv:
            return sdk.startDeviceMeasurement(withType: 1, isOpen: true, isPPG_Open: true, isPPI_Open: false) as Data?
            
        case .heartRate:
            return sdk.startDeviceMeasurement(withType: 2, isOpen: true, isPPG_Open: true, isPPI_Open: false) as Data?
            
        case .spo2:
            return sdk.startDeviceMeasurement(withType: 3, isOpen: true, isPPG_Open: true, isPPI_Open: false) as Data?
            
        
       ///Mark:- Other Data
        case .gps:
            return sdk.appSend(toDevice: 1.5, pace_Minutes: 6, pace_Seconds: 30, gps_SignalStrength: 4) as Data?
            
        case .bloodPressure:
            return nil
       
            
        case .temperature:
            return nil // No matching method found in `BleSDK.h` for temperature
        }
    }
}
