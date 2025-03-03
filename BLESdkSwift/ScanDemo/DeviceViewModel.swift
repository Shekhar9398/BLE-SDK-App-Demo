import Foundation
import Combine

class DeviceViewModel: ObservableObject {
    @Published var batteryLevel: String = "Fetching..."
    @Published var deviceTime: String = "Fetching..."
    @Published var ecg: [Int] = [] // Now stores only ECG values, not ECGData objects

    private var cancellables = Set<AnyCancellable>()
    private let bleModel = BLEManager.shared.bleModel

    init() {
        observeBLEData()
    }

    private func observeBLEData() {
        // Observe Battery Level
        bleModel.$batteryLevel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] level in
                self?.batteryLevel = level != nil ? "\(level!)%" : "Error fetching"
            }
            .store(in: &cancellables)

        // Observe Device Time
        bleModel.$deviceTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.deviceTime = time
            }
            .store(in: &cancellables)

        // Observe ECG Data (Convert ECGData to [Int])
        bleModel.$ecgData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newECGData in
                guard let self = self else { return }

                if let firstECG = newECGData.first {
                    print("New ECG Data Received: \(firstECG.ecgValues)")
                    self.ecg = firstECG.ecgValues // Extract only the ECG values
                }
            }
            .store(in: &cancellables)
    }

    func fetchData() {
        print("Fetching Data from BLEManager...")
        BLEManager.shared.fetchData(for: .batteryLevel)
        BLEManager.shared.fetchData(for: .deviceTime)
        BLEManager.shared.fetchData(for: .ecg)
    }
}
