import SwiftUI

// MARK: - Content View
struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)).ignoresSafeArea()
                VStack {
                    Text("EcoBuddy 🌱")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 15)
                    
                    Text("Your Guide to a Greener Future")
                        .padding(.bottom, 20)
                        .foregroundStyle(Color.black)
                        .italic()
                    
                    Image("energyBulb")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .foregroundColor(.green)
                        .padding(.bottom, 20)
                    
                    NavigationLink(destination: DashboardView()) {
                        Text("Welcome")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.mint)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
    }
}

// MARK: - Content View Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
