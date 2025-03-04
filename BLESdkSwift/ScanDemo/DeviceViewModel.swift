import Foundation
import Combine

class DeviceViewModel: ObservableObject {
    @Published var batteryLevel: String = "Fetching..."
    @Published var deviceTime: String = "Fetching..."
    @Published var ecg: [Int] = [] // Rolling ECG buffer

    private var cancellables = Set<AnyCancellable>()
    private let bleModel = BLEManager.shared.bleModel

    // ECG Data Configuration
    private let maxVisiblePoints = 2000  // Keep 2000 points (30 sec of data)
    private let updateInterval = 0.05     // Update UI every 50ms

    init() {
        observeBLEData()
    }

    private func observeBLEData() {
        // Observe battery level changes
        bleModel.$batteryLevel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] level in
                self?.batteryLevel = level.map { "\($0)%" } ?? "Error fetching"
            }
            .store(in: &cancellables)

        // Observe device time changes
        bleModel.$deviceTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.deviceTime = time
            }
            .store(in: &cancellables)

        // Observe ECG data changes
        bleModel.$ecgData
            .receive(on: DispatchQueue.main)
            .throttle(for: .seconds(updateInterval), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] newECGData in
                guard let self = self, !newECGData.isEmpty else { return }
                let firstECG = newECGData.first!

                print("🔵 New ECG Data Received: \(firstECG.ecgValues)")

                // Append new data
                self.ecg.append(contentsOf: firstECG.ecgValues)

                // Keep only the last `maxVisiblePoints` data for smooth display
                while self.ecg.count > self.maxVisiblePoints {
                    self.ecg.removeFirst(self.ecg.count - self.maxVisiblePoints)
                }
            }
            .store(in: &cancellables)
    }

    // Separate Fetch Functions for Each Button
    func fetchBatteryLevel() {
        print("⚡ Fetching Battery Level...")
        BLEManager.shared.fetchData(for: .batteryLevel)
    }

    func fetchDeviceTime() {
        print("⏰ Fetching Device Time...")
        BLEManager.shared.fetchData(for: .deviceTime)
    }

    func fetchECGData() {
        print("💓 Fetching ECG Data...")
        BLEManager.shared.fetchData(for: .ecg)
    }
}
