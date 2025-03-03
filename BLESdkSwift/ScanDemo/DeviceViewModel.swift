import Foundation
import Combine

class DeviceViewModel: ObservableObject {
    @Published var batteryLevel: String = "Fetching..."
    @Published var deviceTime: String = "Fetching..."
    @Published var ecg: String = "ecg data"

    private var cancellables = Set<AnyCancellable>()
    private let bleModel = BLEManager.shared.bleModel

    init() {
        observeBLEData()
    }
    
    private func observeBLEData() {
        bleModel.$batteryLevel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] level in
                print("ViewModel Received Battery Update: \(level ?? -1)")
                self?.batteryLevel = level != nil ? "\(level!)%" : "Error fetching"
            }
            .store(in: &cancellables)
        
        bleModel.$deviceTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                print("ViewModel Received Device Time Update: \(time)")
                self?.deviceTime = time
            }
            .store(in: &cancellables)
        
//        bleModel.$ecgData
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] liveEcg in
//                self?.ecg = liveEcg.map { "\($0)" }.joined(separator: ", ") // Convert array to a string
//            }
//            .store(in: &cancellables)

    }

    func fetchData() {
        print("Fetching Data from BLEManager...")
        BLEManager.shared.fetchData(for: .batteryLevel)
        BLEManager.shared.fetchData(for: .deviceTime)
//        BLEManager.shared.fetchData(for: .ecg)
    }
}
