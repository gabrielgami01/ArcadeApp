import Foundation

@Observable
final class SessionVM {
    let repository: RepositoryProtocol
    
    var activeSession: Session? = nil
    var sessionDuration: Int = 0
    
    var timer: Timer? = nil
    var isTimerRunning = false
    
    var errorMsg = ""
    var showError = false
    
    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
        
        if SecManager.shared.isLogged {
            Task(priority: .high) {
                await getActiveSession()
            }
            NotificationCenter.default.addObserver(forName: .login, object: nil, queue: .main) { [self] _ in
                Task(priority: .high) {
                    await getActiveSession()
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .login, object: nil)
    }
    
    func getActiveSession() async {
        do {
            let activeSession = try await repository.getActiveSession()
            await MainActor.run {
                startSession(activeSession)
            }
        } catch {
//            await MainActor.run {
//                self.errorMsg = error.localizedDescription
//                self.showError.toggle()
//            }
            print(error.localizedDescription)
        }
    }
    
    func startSessionAPI(gameID: UUID) async -> Bool {
        do {
            try await repository.startSession(gameID: gameID)
            return true
        } catch {
            await MainActor.run {
                self.errorMsg = error.localizedDescription
                self.showError.toggle()
            }
            print(error.localizedDescription)
            return false
        }
    }
    
    
    func startSession(_ session: Session) {
        sessionDuration = Int(Date().timeIntervalSince(session.start))
        self.activeSession = session
        startTimer()
    }
    
    func endSessionAPI() async -> Bool {
        do {
            if let activeSession {
                try await repository.endSession(id: activeSession.id)
                return true
            } else {
                return false
            }
        } catch {
            await MainActor.run {
                self.errorMsg = error.localizedDescription
                self.showError.toggle()
            }
            print(error.localizedDescription)
            return false
        }
    }
    
    func endSession() {
        activeSession = nil
        finishTimer()
    }
    
    func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            sessionDuration += 1
        }
    }
    
    
    func finishTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
        sessionDuration = 0
    }

    
}
