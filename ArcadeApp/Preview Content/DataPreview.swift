import SwiftUI
import SwiftData

func loadData(file: String) throws -> [Game] {
    guard let url = Bundle.main.url(forResource: file, withExtension: "json") else { return [] }
    let data = try Data(contentsOf: url)
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    return try decoder.decode([Game].self, from: data)
}


struct TestInteractor: DataInteractor {
    func register(user: CreateUserDTO) async throws {}
    
    func login(user: String, pass: String) async throws  -> User {
        .test
    }
    
    func refreshJWT() async throws -> User {
        .test
    }

    func updateUserAbout(_ updateUserDTO: UpdateUserDTO) async throws {}
    
    func updateUserAvatar(_ updateUserDTO: UpdateUserDTO) async throws {}
    
    func getAllGames(page: Int) async throws -> [Game] {
        try loadData(file: "games")
    }
    
    func getGamesByConsole(_ console: Console, page: Int) async throws -> [Game] {
        try loadData(file: "games").filter { $0.console == console }
    }
    
    func searchGame(name: String) async throws -> [Game] {
        try loadData(file: "games").filter { $0.name.localizedStandardContains(name) }
    }
    
    func getFeaturedFavoriteGames() async throws -> (featured: [Game], favorites: [Game]) {
        let featured = try loadData(file: "games").filter { $0.featured}
        let favorites = Array(try loadData(file: "games").prefix(8))
        
        return (featured, favorites)
    }
    
    func getGameDetails(id: UUID) async throws -> (favorite: Bool, reviews: [Review], scores: [Score]) {
        return (true, [Review.test,Review.test2,Review.test3], [Score.test, Score.test2, Score.test3, Score.test4, Score.test5])
    }
    
    
    func addFavoriteGame(_ game: FavoriteDTO) async throws {}
    
    func deleteFavoriteGame(id: UUID) async throws {}
    
    func addReview(_ review: CreateReviewDTO) async throws {}

    func addScore(_ score: CreateScoreDTO) async throws {}
    
    func getChallenges() async throws -> [Challenge] {
        return [.test, .test2, .test3, .test4, .test5].sorted { $0.game < $1.game}
    }

    func getActiveUserEmblems() async throws -> [Emblem] {
        [.test, .test2]
    }
    
    func getUserEmblems(id: UUID) async throws -> [Emblem] {
        [.test, .test2, .test3]
    }
    
    func addEmblem(_ emblemDTO: CreateEmblemDTO) async throws {}
    
    func deleteEmblem(challengeID: UUID) async throws {}
    
    func getGameRanking(id: UUID, page: Int) async throws -> [RankingScore] {
        let scores: [RankingScore] = [.test, .test2, .test3, .test4, .test5, .test6, .test7, .test8]
        return scores.sorted { $0.score > $1.score}
    }

    func getFollowingFollowers() async throws -> (following: [UserConnections], followers: [UserConnections]) {
        ([.test, .test2], [.test, .test3])
    }
    
    func followUser(_ connectionsDTO: ConnectionsDTO) async throws {}
    
    func unfollowUser(id: UUID) async throws {}
}

extension User {
    static let test = User(id: UUID(), 
                           email: "gabrielgmcv01@gmail.com",
                           username: "gabrielgm", 
                           fullName: "Gabriel Garcia Millan",
                           about: "De locos",
                           avatarImage: Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAACXBIWXMAAAsTAAALEwEAmpwYAAADPElEQVR4nO2av2/TQBTHT5EYOGaKmjJAuzGylQW2CjH4OpYByD8AXSJFTF3I1g5IdCBE6oL4KUAiIFGkoiYNceNEatKIEpVKqI0UZcvQSiTLobvUruXYjZvYd5f4vtJXOTmR/d7HvucX+wCQkpKS6kOtzyDbTgEsglspkAGs1RYgcbO5Avi3dg0fbc0zNTmmWAAqC0wtFIC2AGYOoJUCGYGKYBpw0/W7mKt5C6IY5mlhABS3yrhcZuNiaVs8AI1GAzebTSYmx2IOQIXKRg4iLXthdswOgBGcWsF7T17STz/G+nHsAJDYVIgKKlS87wxVumOEc+eVbTMEOwC70YQRuNdjJwAkJhIbjREizXMAWYcDWAHoPtxZxIc7S56OzbYCcDpB3kOASMtBlO4F4OhXnNrL8ekAlIzdFPVd0ALg534DL2h79NOP8Wk1gIugDYD57K4RuNdj5gBUiLJkbnXcXV2dpoDfdgLQK94+ACgZfYfmuS8ugNPj9VxwAAD6Lc5LAMwFBwBQfZykHhoAWZtOq18Ab3/X8KXkBvW7am1gAE6dKrdGqNnD4680DFZU6vBrzQMAPjdCqstWuPZ+HRcmI7gwFcG1D+muwMs3o7RAkcRDT1epyZhsK92K9g3A91ZYdei0rAC0yQfHtyCEtalIV+D6dyTpc7EVah0A8SA1wK5T9V3QAmDzyj0jmc2r95kC4CJoAVBKfMT58RmcD8/g0otPXYHnpx/i/I1HXQ859O1DD6Ber+O/zwE1GVsDr1ar1G63Dw2AVe2kodGf1p61srv1t3xFPADQZB1AoB6KwqADCC19NRobq0OLX1wnlAzPGXeExMScsf27aYqR6SYcAOCQvG63AE7+ynbs1GlyB9CS6wMA83eAzTcdC/FytM0BwJ/ljiWAVECvgKZIU6Al1wccS64PiDHp+ITvBGEPZ5ITruf6evLy6AFon7HgSQBoRK+AQrzjwF4BhTjAxSADaMsaAIJZBH8sX3R99teejY0egNB0xPXqT/LbkQMAfTLv/IEEgAJ6Bahw9o4KUc36EJO1c1A5yEF0mzmAHFQOeCdvWgu0zxyAKkDiZnMAoBirsXib6XoAKSkpMEr6DyN3iOvnd7E9AAAAAElFTkSuQmCC"))
    static let test2 = User(id: UUID(),
                           email: "serganri@gmail.com",
                           username: "ssergiogr",
                           fullName: "Sergio Gancedo Rico",
                           about: "Work smart not hard",
                           avatarImage: nil)
}

extension UserConnections {
    static let test = UserConnections(id: UUID(),
                               user: .test,
                               createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 1))!
    )
    static let test2 = UserConnections(id: UUID(),
                               user: .test2,
                               createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 3))!
    )
    static let test3 = UserConnections(id: UUID(),
                               user: .test2,
                               createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 9, hour: 22, minute: 01))!
    )
}

extension Game {
    static let test = Game(id: UUID(uuidString: "f29eac70-e200-4e54-b878-efcdaa9413e3") ?? UUID(),
                           name: "Pokémon Red and Blue",
                           description: "An rpg game where players capture and train Pokémon to become the Pokémon Champion.",
                           console: .gameboy,
                           genre: .rpg,
                           releaseDate: Calendar.current.date(from: DateComponents(year: 1996, month: 2, day: 27))!,
                           featured: true)
    static let test2 = Game(id: UUID(uuidString: "373c6689-5674-45ba-b82f-3ff64622dd8c") ?? UUID(),
                           name: "Super Mario Bros.",
                           description: "A platform game where players control Mario and Luigi to save Princess Toadstool.",
                           console: .nes,
                           genre: .platformer,
                           releaseDate: Calendar.current.date(from: DateComponents(year: 1985, month: 9, day: 13))!,
                           featured: false)
}

extension Review {
    static let test = Review(id: UUID(),
                             title: "Juego increíble",
                             comment: "Me ha encantado el juego es adictivo",
                             rating: 3,
                             date: .now,
                             user: .test)
    static let test2 = Review(id: UUID(),
                              title: "Muy aburrido",
                              comment: nil,
                              rating: 1,
                              date: .now,
                              user: .test)
    static let test3 = Review(id: UUID(),
                              title: "WOW",
                              comment: "El mejor juego de la historia",
                              rating: 5,
                              date: .now,
                              user: .test)
}

extension Score {
    static let test = Score(id: UUID(),
                            score: nil,
                            status: .unverified,
                            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 1, hour: 22, minute: 30)) ?? .now)
    static let test2 = Score(id: UUID(),
                            score: 5500,
                            status: .verified,
                            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 3, hour: 15, minute: 30)) ?? .now)
    static let test3 = Score(id: UUID(),
                            score: 6000,
                            status: .verified,
                            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5, hour: 15, minute: 22)) ?? .now)
    static let test4 = Score(id: UUID(),
                            score: 4440,
                            status: .verified,
                            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 10, hour: 16, minute: 33)) ?? .now)
    static let test5 = Score(id: UUID(),
                            score: 5323,
                            status: .verified,
                            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 22, hour: 14, minute: 02)) ?? .now)
}

extension Challenge {
    static let test = Challenge(id: UUID(),
                                name: "Mushroom Champion",
                                description: "Score 100,000 points by collecting coins and defeating enemies.",
                                targetScore: 100000,
                                type: .gold,
                                game: "Super Mario Bros",
                                isCompleted: true)
    
    static let test2 = Challenge(id: UUID(),
                                 name: "Hero of Hyrule",
                                 description: "Reach a score of 50,000 points by defeating bosses and collecting items.",
                                 targetScore: 50000,
                                 type: .bronze,
                                 game: "The Legend of Zelda",
                                 isCompleted: true)
    static let test3 = Challenge(id: UUID(),
                                 name: "Speed Demon",
                                 description: "Achieve a score of 75,000 points by collecting rings and defeating Dr. Robotnik.",
                                 targetScore: 75000,     
                                 type: .gold,
                                 game: "Sonic the Hedgehog",
                                 isCompleted: false)
    
    static let test4 = Challenge(id: UUID(),
                                 name: "Martial Arts Master",
                                 description: "Score 80,000 points by winning matches in Street Fighter II.",
                                 targetScore: 80000,
                                 type: .bronze,
                                 game: "Street Fighter II",
                                 isCompleted: true)
    static let test5 = Challenge(id: UUID(),
                                 name: "Mako Reactor Hero",
                                 description: "Reach a score of 60,000 points by completing quests and defeating enemies.",
                                 targetScore: 60000,
                                 type: .silver,
                                 game: "Final Fantasy VII",
                                 isCompleted: false)
    
}

extension Emblem {
    static let test = Emblem(id: UUID(),
                             challenge: .test)
    static let test2 = Emblem(id: UUID(),
                             challenge: .test2)
    static let test3 = Emblem(id: UUID(),
                             challenge: .test3)
    static let test4 = Emblem(id: UUID(),
                             challenge: .test4)
    static let test5 = Emblem(id: UUID(),
                             challenge: .test5)
}

extension RankingScore {
    static let test = RankingScore(id: UUID(),
                                   score: 5500,
                                   date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 1, hour: 22, minute: 30)) ?? .now,
                                   user: .test)
    static let test2 = RankingScore(id: UUID(),
                                    score: 6000,
                                    date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5, hour: 15, minute: 22)) ?? .now,
                                    user: .test2)
    static let test3 = RankingScore(id: UUID(),
                                    score: 4440,
                                    date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 10, hour: 16, minute: 33)) ?? .now,
                                    user: .test2)
    static let test4 = RankingScore(id: UUID(),
                                    score: 5323,
                                    date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 22, hour: 14, minute: 02)) ?? .now,
                                    user: .test)
    static let test5 = RankingScore(id: UUID(),
                                    score: 3223,
                                    date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 2, hour: 14, minute: 02)) ?? .now,
                                    user: .test)
    static let test6 = RankingScore(id: UUID(),
                                    score: 6546,
                                    date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 5, hour: 14, minute: 02)) ?? .now,
                                    user: .test2)
    static let test7 = RankingScore(id: UUID(),
                                    score: 2555,
                                    date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 10, hour: 14, minute: 02)) ?? .now,
                                    user: .test)
    static let test8 = RankingScore(id: UUID(),
                                    score: 9393,
                                    date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 22, hour: 14, minute: 02)) ?? .now,
                                    user: .test2)
}

struct SwiftDataPreview: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modelContainer(for: GameModel.self, inMemory: true) { result in
                if case .success(let container) = result {
                    let game = GameModel(id: UUID(),
                                         name: "Pokémon Red and Blue",
                                         desc: "An rpg game where players capture and train Pokémon to become the Pokémon Champion.",
                                         console: "Gameboy",
                                         genre: "RPG",
                                         releaseDate: Calendar.current.date(from: DateComponents(year: 1996, month: 2, day: 27))!,
                                         added: .now)
                    container.mainContext.insert(game)
                }
            }
    }
}

extension View {
    var swiftDataPreview: some View {
        modifier(SwiftDataPreview())
    }
}
