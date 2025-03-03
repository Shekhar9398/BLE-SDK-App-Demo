import Foundation

class BLEModel: ObservableObject {
    // General Device Info
    @Published var deviceTime: String = "Fetching..."
    @Published var batteryLevel: Int? = nil
    @Published var macAddress: String = "Fetching..."
    @Published var deviceVersion: String = "Fetching..."
    @Published var stepGoal: Int? = nil
    @Published var deviceName: String = "Fetching..."
    
    // Personal Info
    @Published var personalInfo: PersonalInfo?
    
    // Device Settings
    @Published var deviceInfo: DeviceInfo?
    @Published var automaticMonitoring: AutomaticMonitoring?
    @Published var sedentaryReminder: SedentaryReminder?
    @Published var alarmClocks: [AlarmClock] = []
    
    // Activity & Health Data
    @Published var realTimeStepCount: Int = 0
    @Published var totalActivityData: [ActivityData] = []
    @Published var detailActivityData: [ActivityData] = []
    @Published var detailSleepData: SleepData?
    
    // Heart Rate & HRV
    @Published var dynamicHeartRate: [Int] = []
    @Published var staticHeartRate: [Int] = []
    @Published var heartRateVariability: [HRVData] = []
    
    // Blood Oxygen & Temperature
    @Published var automaticSpo2Data: [Spo2Data] = []
    @Published var manualSpo2Data: [Spo2Data] = []
    @Published var bodyTemperature: TemperatureData?
    
    // GPS & Activity Mode
    @Published var gpsData: [GPSData] = []
    @Published var activityModeData: [ActivityModeData] = []
    
    // Weather
    @Published var weather: WeatherParameter?
    
    // Misc
    @Published var sosTriggered: Bool = false
    @Published var screenLocked: Bool = false
    @Published var ppgMeasurementInProgress: Bool = false
    @Published var ecgData: [ECGData] = []
    
    // UI Update Control
    @Published var shouldUpdateView: Bool = false
}
