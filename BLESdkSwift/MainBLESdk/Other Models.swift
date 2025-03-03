

import Foundation
struct ActivityData {
    var steps: Int
    var distance: Double
    var caloriesBurned: Double
    var duration: Int
}

struct SleepData {
    var totalSleep: Int
    var deepSleep: Int
    var lightSleep: Int
    var awakeTime: Int
}

struct HRVData {
    var timestamp: Date
    var hrvValue: Int
}

struct Spo2Data {
    var timestamp: Date
    var spo2Level: Int
}

struct TemperatureData {
    var timestamp: Date
    var temperature: Double
}

struct GPSData {
    var timestamp: Date
    var latitude: Double
    var longitude: Double
    var speed: Double
}

struct ActivityModeData {
    var modeType: String
    var startTime: Date
    var endTime: Date
    var caloriesBurned: Double
}

struct ECGData {
    var timestamp: Date
    var ecgValues: [Int]
}
