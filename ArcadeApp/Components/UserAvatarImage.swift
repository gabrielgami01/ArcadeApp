import SwiftUI

struct UserAvatarImage: View {
    let imageData: Data?
    var height: CGFloat = 100
    var width: CGFloat = 100
    
    var body: some View {
        if let avatar = imageData {
            if let image = UIImage(data: avatar) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 3)
                    }
                    
            }
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    UserAvatarImage(imageData: Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAACXBIWXMAAAsTAAALEwEAmpwYAAADPElEQVR4nO2av2/TQBTHT5EYOGaKmjJAuzGylQW2CjH4OpYByD8AXSJFTF3I1g5IdCBE6oL4KUAiIFGkoiYNceNEatKIEpVKqI0UZcvQSiTLobvUruXYjZvYd5f4vtJXOTmR/d7HvucX+wCQkpKS6kOtzyDbTgEsglspkAGs1RYgcbO5Avi3dg0fbc0zNTmmWAAqC0wtFIC2AGYOoJUCGYGKYBpw0/W7mKt5C6IY5mlhABS3yrhcZuNiaVs8AI1GAzebTSYmx2IOQIXKRg4iLXthdswOgBGcWsF7T17STz/G+nHsAJDYVIgKKlS87wxVumOEc+eVbTMEOwC70YQRuNdjJwAkJhIbjREizXMAWYcDWAHoPtxZxIc7S56OzbYCcDpB3kOASMtBlO4F4OhXnNrL8ekAlIzdFPVd0ALg534DL2h79NOP8Wk1gIugDYD57K4RuNdj5gBUiLJkbnXcXV2dpoDfdgLQK94+ACgZfYfmuS8ugNPj9VxwAAD6Lc5LAMwFBwBQfZykHhoAWZtOq18Ab3/X8KXkBvW7am1gAE6dKrdGqNnD4680DFZU6vBrzQMAPjdCqstWuPZ+HRcmI7gwFcG1D+muwMs3o7RAkcRDT1epyZhsK92K9g3A91ZYdei0rAC0yQfHtyCEtalIV+D6dyTpc7EVah0A8SA1wK5T9V3QAmDzyj0jmc2r95kC4CJoAVBKfMT58RmcD8/g0otPXYHnpx/i/I1HXQ859O1DD6Ber+O/zwE1GVsDr1ar1G63Dw2AVe2kodGf1p61srv1t3xFPADQZB1AoB6KwqADCC19NRobq0OLX1wnlAzPGXeExMScsf27aYqR6SYcAOCQvG63AE7+ynbs1GlyB9CS6wMA83eAzTcdC/FytM0BwJ/ljiWAVECvgKZIU6Al1wccS64PiDHp+ITvBGEPZ5ITruf6evLy6AFon7HgSQBoRK+AQrzjwF4BhTjAxSADaMsaAIJZBH8sX3R99teejY0egNB0xPXqT/LbkQMAfTLv/IEEgAJ6Bahw9o4KUc36EJO1c1A5yEF0mzmAHFQOeCdvWgu0zxyAKkDiZnMAoBirsXib6XoAKSkpMEr6DyN3iOvnd7E9AAAAAElFTkSuQmCC"),
                    height: 100, width: 100)
    .preferredColorScheme(.dark)
}
