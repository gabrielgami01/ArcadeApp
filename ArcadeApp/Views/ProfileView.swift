import SwiftUI

struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(BadgesVM.self) private var badgesVM

    @State private var showEditAbout = false
    @State private var showAddEmblem = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                if let user = userVM.activeUser {
                    ProfileCard(user: user)

                    Form {
                        Section {
                            BadgesCard(badges: badgesVM.featuredBadges) { badge in
                                Button {
                                    badgesVM.selectedBadge = badge
                                    showAddEmblem.toggle()
                                } label: {
                                    BadgeCard(type: .display, badge: badge)
                                }
                            } emptyBadge: { index in
                                Button {
                                    badgesVM.selectedOrder = index + badgesVM.featuredBadges.count
                                    showAddEmblem.toggle()
                                } label: {
                                    BadgeCard(type: .add)
                                }
                            }
                        } header: {
                            Text("Personal card")
                                .font(.customTitle3)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.card)

                        Section {
                            HStack {
                                Text(user.about ?? "")

                                Spacer()

                                Button {
                                    showEditAbout = true
                                } label: {
                                    Text(">")
                                }
                                .foregroundStyle(.secondary)

                            }
                        } header: {
                            Text("About")
                                .font(.customTitle3)
                        }
                        .font(.customBody)
                        .listRowBackground(Color.card)

                        Section {
                            Button(role: .destructive) {
                                userVM.logout()
                            } label: {
                                Text("Log Out")
                            }
                        }
                        .font(.customBody)
                        .listRowBackground(Color.card)

                    }
                }
            }
            .task {
                await badgesVM.getBadges()
            }
            .navigationDestination(for: ConnectionOptions.self) { page in
                switch page {
                    case .following:
                        ConnectionsView(selectedPage: page)
                    case .followers:
                        ConnectionsView(selectedPage: page)
                }
            }
            .sheet(isPresented: $showEditAbout) {
                EditAboutView()
            }
            .sheet(isPresented: $showAddEmblem) {
                AddBadgeView()
            }
            .scrollContentBackground(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            .scrollIndicators(.hidden)
            .background(Color.background)
        }
    }
}

#Preview {
    ProfileView()
        .environment(UserVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
        .environment(BadgesVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
