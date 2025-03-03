import Foundation

//datatypes
enum DataType: Int {
    case getDeviceTime = 0
    case setDeviceTime
    case getPersonalInfo
    case setPersonalInfo
    case getDeviceInfo
    case setDeviceInfo
    case setDeviceID
    case getDeviceGoal
    case setDeviceGoal
    case getDeviceBattery
    case getDeviceMacAddress
    case getDeviceVersion
    case factoryReset
    case mcuReset
    case motorVibration
    case getDeviceName
    case setDeviceName
    case getAutomaticMonitoring
    case setAutomaticMonitoring
    case getAlarmClock
    case setAlarmClock
    case deleteAllAlarmClock
    case getSedentaryReminder
    case setSedentaryReminder
    case realTimeStep
    case totalActivityData
    case detailActivityData
    case detailSleepData
    case dynamicHR
    case staticHR
    case activityModeData
    case enterActivityMode
    case quitActivityMode
    case deviceSendDataToApp
    case enterTakePhotoMode
    case startTakePhoto
    case stopTakePhoto
    case backHomeView
    case hrvData
    case gpsData
    case setSocialDistanceReminder
    case getSocialDistanceReminder
    case automaticSpo2Data
    case manualSpo2Data
    case findMobilePhone
    case temperatureData
    case axillaryTemperatureData
    case sos
    case ecgHistoryData
    case startECG
    case stopECG
    case ecgRawData
    case ecgSuccessResult
    case ecgStatus
    case ecgFailed
    case deviceMeasurementHR
    case deviceMeasurementHRV
    case deviceMeasurementSpo2
    case unlockScreen
    case lockScreen
    case clickYesWhenUnlockScreen
    case clickNoWhenUnlockScreen
    case setWeather
    case openRRInterval
    case closeRRInterval
    case realtimeRRIntervalData
    case realtimePPIData
    case realtimePPGData
    case ppgStartSuccess
    case ppgStartFailed
    case ppgResult
    case ppgStop
    case ppgQuit
    case ppgMeasurementProgress
    case clearAllHistoryData
    case dataError = 255
}

//Models
struct DeviceTime {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int
}

struct PersonalInfo {
    var gender: Int
    var age: Int
    var height: Int
    var weight: Int
    var stride: Int
}

struct NotificationType {
    var call: Int
    var SMS: Int
    var wechat: Int
    var facebook: Int
    var instagram: Int
    var skype: Int
    var telegram: Int
    var twitter: Int
    var vkclient: Int
    var whatsapp: Int
    var qq: Int
    var linkedIn: Int
}

struct DeviceInfo {
    var distanceUnit: Int
    var timeUnit: Int
    var wristOn: Int
    var temperatureUnit: Int
    var notDisturbMode: Int
    var ANCS: Int
    var notificationType: NotificationType
    var baseHeartRate: Int
    var screenBrightness: Int
    var watchFaceStyle: Int
    var socialDistanceRemind: Int
    var language: Int
}

struct Weeks {
    var sunday: Bool
    var monday: Bool
    var tuesday: Bool
    var wednesday: Bool
    var thursday: Bool
    var friday: Bool
    var saturday: Bool
}

struct AutomaticMonitoring {
    var mode: Int
    var startTimeHour: Int
    var startTimeMinutes: Int
    var endTimeHour: Int
    var endTimeMinutes: Int
    var weeks: Weeks
    var intervalTime: Int
    var dataType: Int
}

struct SedentaryReminder {
    var startTimeHour: Int
    var startTimeMinutes: Int
    var endTimeHour: Int
    var endTimeMinutes: Int
    var weeks: Weeks
    var intervalTime: Int
    var leastSteps: Int
    var mode: Int
}

struct AlarmClock {
    var openOrClose: Int
    var clockType: Int
    var endTimeHour: Int
    var endTimeMinutes: Int
    var weeks: Int
    var intervalTime: Int
    var leastSteps: Int
    var mode: Int
}

struct WeatherParameter {
    var weatherType: Int
    var currentTemperature: Int
    var highestTemperature: Int
    var lowestTemperature: Int
    var city: String
}
