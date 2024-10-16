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
                VStack(alignment: .leading, spacing: 25) {
                    PointView(symbol: "list.bullet.clipboard.fill",
                              title: "List of Games and Details",
                              subTitle: "Explore a list of available games with detailed descriptions and images.")
                    PointView(symbol: "magnifyingglass",
                              title: "Sorting and Filtering",
                              subTitle: "Sort the available games by console.\nSearch the games that interest you the most.")
                    PointView(symbol: "heart.fill",
                              title: "Favorites",
                              subTitle: "Add the games you like the most to your favorites list for quick access.")
                    PointView(symbol: "info.bubble.fill",
                              title: "Reviews and Ratings",
                              subTitle: "Read reviews and ratings from other users.\nLeave your own feedback and rate the games you’ve played.")
                    PointView(symbol: "info.bubble.fill",
                              title: "Score History",
                              subTitle: "Upload your scores and visualize your progress over time through detailed charts.\nAttach an image of the score for later verification.")
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 25) {
                    PointView(symbol: "trophy",
                              title: "Challenges",
                              subTitle: "Each game includes challenges with target scores that challenge you to improve.\nComplete challenges and earn unique emblems to display on your profile.")
                    PointView(symbol: "rosette",
                              title: "Rankings",
                              subTitle: "View the global score ranking for each game, only with verified scores.")
                    PointView(symbol: "person.2.fill",
                              title: "Social",
                              subTitle: "Follow other users and see who follows you.\nAccess the profile cards of other users.")
                    PointView(symbol: "person.2.fill",
                              title: "Social",
                              subTitle: "Follow other users and see who follows you.\nAccess the profile cards of other users.")
                    PointView(symbol: "person.fill",
                              title: "Profile",
                              subTitle: "Choose your avatar and add a personal biography.\nDisplay your emblems on your user card.")
                    
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
                    .padding(.bottom, 50)
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

struct PointView: View {
    let symbol: String
    let title: String
    let subTitle: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(.accent)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.customTitle3)
                
                Text(subTitle)
                    .font(.customBody)
                    .foregroundStyle(.gray)
            }
        }
    }
}
