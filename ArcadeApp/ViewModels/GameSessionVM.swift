import Foundation

@Observable
final class GameSessionVM {
    let repository: RepositoryProtocol
    
    var activeSession: GameSession? = nil
    var sessionDuration: Int = 0
    
    var timer: Timer? = nil
    var isTimerRunning = false
    
    var errorMsg = ""
    var showError = false
    
    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
        Task {
            await getActiveGameSession()
        }
    }
    
    func getActiveGameSession() async {
        do {
            let activeSession = try await repository.getActiveGameSession()
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
            let gameDTO = GameDTO(gameID: gameID)
            try await repository.startGameSession(gameDTO)
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
    
    
    func startSession(_ session: GameSession) {
        sessionDuration = Int(Date().timeIntervalSince(session.start))
        self.activeSession = session
        startTimer()
    }
    
    func endSessionAPI() async -> Bool {
        do {
            if let activeSession {
                try await repository.endGameSession(id: activeSession.id)
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
