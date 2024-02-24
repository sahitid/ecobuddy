import SwiftUI

// MARK: - Challenge Model
struct Challenge {
    let name: String
    let picture: String
    let description: String
}

// MARK: - Dashboard View
struct DashboardView: View {
    @State private var selectedTab = 0
    @State private var key = UUID()

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HeaderView()
                        PointsCardView(action: {
                            selectedTab = 1
                        })
                        ChallengesView()
                    }
                    .padding()
                    .navigationBarHidden(true)
                }
                .background(Color(red: 244/255, green: 242/255, blue: 236/255))
                .id(key)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            
            EcoQuizView()
                .tabItem {
                    Label("EcoQuiz", systemImage: "questionmark.circle")
                }
                .tag(1)
        }
        .accentColor(.black)
        .background(Color(red: 244/255, green: 242/255, blue: 236/255).edgesIgnoringSafeArea(.all))
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
        .onChange(of: selectedTab) { newValue in
            if newValue == 0 {
                key = UUID()
            }
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello,")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Get ready to energize your day")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Points Card View
struct PointsCardView: View {
    var action: () -> Void
    
    @EnvironmentObject var sharedData: SharedData
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(String(sharedData.points))
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Text("Points")
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                }
                
                Text("Complete the next daily challenge to earn 50 points.")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            NavigationLink(destination: EcoQuizView()) {
                Text("Start EcoQuiz")
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 117/255, green: 159/255, blue: 149/255))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .simultaneousGesture(TapGesture().onEnded {
                action()
            })
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            Image("backgroundImage")
                .resizable()
                .scaledToFill()
        )
        .background(Color.black.opacity(0.6))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

// MARK: - Challenges View
struct ChallengesView: View {
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    let challenges = [
        Challenge(name: "Say NO to Single Use Plastics!", picture: "bottle", description: """
        Did you know that every year, about 8 million tons of plastic waste escapes into the oceans from coastal nations? This is like dumping the contents of one garbage truck into the ocean every minute. Combat this by saying NO to single-use plastics. Opt for alternatives that can be reused, such as:

        - Bringing your own shopping bags to the grocery store.
        - Choosing a reusable water bottle instead of buying plastic bottles.
        - Using metal or bamboo straws instead of plastic ones.
        """),
        Challenge(name: "Plant a Tree", picture: "tree", description: """
        Astonishingly, the world loses 10 billion trees yearly, which is detrimental to our climate, wildlife, and air quality. Trees are crucial for absorbing CO2, a leading greenhouse gas. You can make a difference by:

        - Planting a tree in your garden or community.
        - Supporting reforestation projects.
        - Educating others about the importance of trees for the environment.
        """),
        Challenge(name: "Use Public Transport", picture: "scooter", description: """
        Vehicles are the largest contributors to U.S. greenhouse gas emissions, with a single passenger vehicle emitting about 4.6 metric tons of carbon dioxide per year. Reduce your carbon footprint by:

        - Using public transport for daily commutes.
        - Carpooling with friends or colleagues.
        - Considering biking or walking for shorter distances.
        """),
        Challenge(name: "Reuse, Restore, Recycle", picture: "recycle", description: """
        A shocking fact: The average person generates over 2 kilograms of waste per day, amounting to a global tally of 2.01 billion tonnes of solid waste annually. Minimize waste by:

        - Recycling paper, plastic, metal, and glass.
        - Donating items you no longer use.
        - Repairing instead of buying new whenever possible.
        """),
        Challenge(name: "Save Water", picture: "waterPipe", description: """
        Over 733 million people, or 10% of the world's population, experience high water stress. The average family can waste 180 gallons per week, or 9,400 gallons annually, from household leaks. Preserve our precious resource by:

        - Fixing leaks promptly in your home.
        - Using water-saving appliances.
        - Collecting rainwater for gardening and other uses.
        """)
    ]

    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Challenges")
                .font(.headline)
                .fontWeight(.bold)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(challenges, id: \.name) { challenge in
                    ChallengeCardView(challenge: challenge)
                }
            }
            .padding(.top)
        }
    }
}

// MARK: - Challenge Card View
struct ChallengeCardView: View {
    @State private var isSheetOpen = false
    var challenge: Challenge
    
    var body: some View {
        VStack {
            Image(challenge.picture)
                .resizable().scaledToFit().frame(width: 160, height: 90)
                .padding(.horizontal)
                .padding(.top)

            Text(challenge.name)
                .fontWeight(.semibold)
                .lineLimit(2)
                .padding(.horizontal, 10)
                .padding(.all, 10)
                .foregroundColor(Color(red:0, green: 0.3, blue:0))
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .frame(width: 175, height: 175)
        .background(Color.green.opacity(0.3))
        .cornerRadius(10)
        .onTapGesture {
            isSheetOpen.toggle()
        }
        .sheet(isPresented: $isSheetOpen) {
            CardView(cardText: challenge.name, cardImage: challenge.picture, cardDescription: challenge.description)
        }
    }
}

// MARK: - Preview
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView().environmentObject(SharedData())
    }
}
