import SwiftUI
import Network

@Observable
final class NetworkStatus {
    enum Status {
        case offline, online, unknown
    }
    
    var status = Status.online
    
    let monitor = NWPathMonitor()
    @ObservationIgnored var queue = DispatchQueue(label: "MonitorNetwork")
    
    init() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [self] path in
            DispatchQueue.main.async {
                self.status = path.status != .unsatisfied ? .online : .offline
            }
        }
    }
}
