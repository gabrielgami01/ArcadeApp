import SwiftUI

@Observable
final class BadgesVM {
    let repository: RepositoryProtocol

    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
    }

    var badges: [Badge] = []
    @ObservationIgnored var featuredBadges: [Badge] {
        badges
            .filter { $0.featured }
            .sorted { ($0.order ?? Int.max) < ($1.order ?? Int.max) }
    }
    @ObservationIgnored var disponibleBadges: [Badge] {
        badges
            .filter { !$0.featured }
    }
    
    var selectedBadge: Badge? = nil
    var selectedOrder: Int? = nil
    
    var userBadges: [Badge] = []

    var errorMsg = ""
    var showError = false

    func getBadges() async {
        do {
            let badges = try await repository.getBadges()
            await MainActor.run {
                self.badges = badges
            }
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func getFeaturedBadges(id: UUID) async {
        do {
            let badges = try await repository.getFeaturedBadges(userID: id)
            await MainActor.run {
                self.userBadges = badges
            }
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
        }
    }
    
    func highlightBadgeAPI(id: UUID, order: Int) async -> Bool {
        do {
            let badgeDTO = HighlightBadgeDTO(id: id, order: order)
            try await repository.highlightBadge(badgeDTO)
            return true
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
            return false
        }
    }
    
    func highlightBadge(_ badge: Badge) {
        if let index = badges.firstIndex(where: { $0.id == badge.id }) {
            badges[index] = badge
        }
    }
    
    func unhighlightBadgeAPI(id: UUID) async -> Bool {
        do {
            try await repository.unhighlightBadge(id: id)
            return true
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                showError.toggle()
            }
            print(error.localizedDescription)
            return false
        }
    }
    
    func unhighlightBadge(_ badge: Badge) {
        badges.removeAll(where: { $0.id == badge.id })
    }

}
