import SwiftUI

struct AddBadgeView: View {
    @Environment(BadgesVM.self) private var badgesVM
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        NavigationStack {
            ScrollView {
                if !badgesVM.disponibleBadges.isEmpty {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(badgesVM.disponibleBadges) { badge in
                            Button {
                                if let selectedBadge = badgesVM.selectedBadge, let order = selectedBadge.order {
                                    Task {
                                        if await badgesVM.unhighlightBadgeAPI(id: selectedBadge.id) {
                                            badgesVM.unhighlightBadge(selectedBadge)
                                            if await badgesVM.highlightBadgeAPI(id: badge.id, order: order) {
                                                let highlightedBadge = Badge(id: badge.id,
                                                                             name: badge.name,
                                                                             featured: true,
                                                                             order: order,
                                                                             challengeType: badge.challengeType,
                                                                             game: badge.game,
                                                                             completedAt: badge.completedAt)
                                                badgesVM.highlightBadge(highlightedBadge)
                                                badgesVM.selectedBadge = nil
                                                dismiss()
                                            }
                                        }
                                    }
                                } else {
                                    if let order = badgesVM.selectedOrder {
                                        Task {
                                            if await badgesVM.highlightBadgeAPI(id: badge.id, order: order) {
                                                let highlightedBadge = Badge(id: badge.id,
                                                                             name: badge.name,
                                                                             featured: true,
                                                                             order: order,
                                                                             challengeType: badge.challengeType,
                                                                             game: badge.game,
                                                                             completedAt: badge.completedAt)
                                                badgesVM.highlightBadge(highlightedBadge)
                                                badgesVM.selectedOrder = nil
                                                dismiss()
                                            }
                                        }
                                    }
                                }
                            } label: {
                                BadgeInfoCard(badge: badge)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } else {
                    CustomUnavailableView(title: "No available badges", image: "trophy",
                                          description: "You haven't any available badge by the moment.")
                }
            }
            .task {
                await badgesVM.getBadges()
            }
            .sheetToolbar(title: "Badges", confirmationLabel: nil, confirmationAction: nil)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .background(Color.background)
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    AddBadgeView()
        .environment(BadgesVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
