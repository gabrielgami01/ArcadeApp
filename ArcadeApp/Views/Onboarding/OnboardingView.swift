import SwiftUI

struct OnboardingView: View {
    @AppStorage("firstTime") private var firstTime: Bool = true
    @State private var step = 1
    
    var body: some View {
        VStack {
            Text("What's new in \nArcade Studios")
                .font(.customLargeTitle)
                .multilineTextAlignment(.center)
            
            TabView {
                VStack(alignment: .leading, spacing: 30) {
                    PointView(symbol: "list.bullet.clipboard",
                              title: "List of Games and Details",
                              subTitle: "Explore a list of available games with detailed descriptions and images.")
                    PointView(symbol: "magnifyingglass",
                              title: "Filter and Searching",
                              subTitle: "Filter games by console and search the games that interest you the most.")
                    PointView(symbol: "heart",
                              title: "Favorites",
                              subTitle: "Add the games you like the most to your favorites list for quick access.")
                    PointView(symbol: "info.bubble",
                              title: "Reviews and Ratings",
                              subTitle: "Read reviews and ratings from other users and leave your own feedback.")
                    PointView(symbol: "chart.xyaxis.line",
                              title: "Score History",
                              subTitle: "Upload your scores and visualize your progress over time through charts.")
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 30) {
                    PointView(symbol: "person",
                              title: "Profile",
                              subTitle: "Choose your avatar and add a personal biography.")
                    PointView(symbol: "play",
                              title: "Active Sessions",
                              subTitle: "Start a gaming session and track how long you play.")
                    PointView(symbol: "trophy",
                              title: "Challenges",
                              subTitle: "Complete challenges and earn unique badges to display on your profile.")
                    PointView(symbol: "rosette",
                              title: "Rankings",
                              subTitle: "View the global score ranking for each game, only with verified scores.")
                    PointView(symbol: "person.2",
                              title: "Social",
                              subTitle: "Follow other users, see who follows you and access the profile cards of other users.")
                    
                    Spacer()
                    
                    Button {
                        firstTime.toggle()
                    } label: {
                        Text("Continue")
                            .font(.customTitle3)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(.accent, in: .rect(cornerRadius: 10))
                    }
                    .padding(.bottom, 80)
                }
            }
            .tabViewStyle(.page)
            
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .background(Color.background)
    }
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
}
