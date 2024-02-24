import SwiftUI

// MARK: - Model
struct QuizQuestion {
    let question: String
    let options: [String]
}

struct QuizResult {
    let totalCO2: Double
    var improvementAreas: [String: Int]
}

// MARK: - View Model
class EcoQuizViewModel: ObservableObject {
    @Published var selectedCountry: String = "USA"
    @Published var selectedCommute: String = "Walk/Bike"
    @Published var flightFrequency: String = "0"
    @Published var selectedDiet: String = "Veggie"
    @Published var selectedEnergy: String = "Renewable"
    
    private let commuteEmissions = ["Walk/Bike": 0, "Car": 4.6, "Public Transport": 2.4]
    private let flightEmissions = 90.0
    private let dietEmissions = ["Veggie": 3.5, "Mixed": 5.5, "Carnivore": 7.5]
    private let energyEmissions = ["Renewable": 0, "Non-Renewable": 8.0, "Mix": 4.0]
    
    func calculateFootprint() -> QuizResult {
        let weeklyCommuteEmissions = commuteEmissions[selectedCommute] ?? 0
        let annualCommuteEmissions = weeklyCommuteEmissions * 52
        
        let annualFlights = Double(flightFrequency) ?? 0
        let annualFlightEmissions = annualFlights * flightEmissions
        
        let dailyDietEmissions = dietEmissions[selectedDiet] ?? 0
        let annualDietEmissions = dailyDietEmissions * 365
        
        let dailyEnergyEmissions = energyEmissions[selectedEnergy] ?? 0
        let annualEnergyEmissions = dailyEnergyEmissions * 365
        
        let totalAnnualEmissions = annualCommuteEmissions + annualFlightEmissions + annualDietEmissions + annualEnergyEmissions
        
        var improvementAreas: [String: Int] = [
            "Commute": selectedCommute == "Walk/Bike" ? 3 : (selectedCommute == "Public Transport" ? 2 : 1),
            "Flying": annualFlights <= 2 ? 3 : 1,
            "Diet": selectedDiet == "Veggie" ? 3 : (selectedDiet == "Mixed" ? 2 : 1),
            "Home Energy": selectedEnergy == "Renewable" ? 3 : (selectedEnergy == "Mix" ? 2 : 1)
        ]
        
        let totalCO2Tonnes = totalAnnualEmissions / 1000
        
        return QuizResult(totalCO2: totalCO2Tonnes, improvementAreas: improvementAreas)
    }
}

// MARK: - Main View
struct EcoQuizView: View {
    @StateObject private var viewModel = EcoQuizViewModel()
    @State private var showingResults = false
    @State private var result: QuizResult?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Country of Residence").font(.headline).foregroundColor(Color.gray)) {
                    TextField("Enter your country", text: $viewModel.selectedCountry)
                }
                
                Section(header: Text("Daily Commute Habits").font(.headline).foregroundColor(Color.gray)) {
                    Picker("Select your commute method", selection: $viewModel.selectedCommute) {
                        ForEach(["Walk/Bike", "Car", "Public Transport"], id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }
                
                Section(header: Text("Annual Flight Frequency").font(.headline).foregroundColor(Color.gray)) {
                    TextField("Enter how often you fly per year", text: $viewModel.flightFrequency)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Diet").font(.headline).foregroundColor(Color.gray)) {
                    Picker("Select your diet", selection: $viewModel.selectedDiet) {
                        ForEach(["Veggie", "Mixed", "Carnivore"], id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }
                
                Section(header: Text("Home Energy Source").font(.headline).foregroundColor(Color.gray)) {
                    Picker("Select your home energy source", selection: $viewModel.selectedEnergy) {
                        ForEach(["Renewable", "Non-Renewable", "Mix"], id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }
                

                    Button(action: {
                        result = viewModel.calculateFootprint()
                        showingResults = true
                    }) {
                        Text("Calculate Footprint")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mint)
                            .cornerRadius(10)
                    }
                
            }
            .navigationBarTitle("EcoQuiz", displayMode: .inline)
            .toolbarColorScheme(.light, for: .navigationBar)
            .sheet(isPresented: $showingResults) {
                ResultsView(result: result ?? QuizResult(totalCO2: 0, improvementAreas: ["Commute": 0, "Flying": 0, "Diet": 0, "Home Energy": 0]))
            }
        }
        .accentColor(.mint)
    }
}

// MARK: - Results View
struct ResultsView: View {
    var result: QuizResult
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    VStack {
                        Text("My carbon footprint:")
                            .font(.headline)
                            .foregroundColor(Color.gray)
                        Text("\(result.totalCO2, specifier: "%.1f") tonnes of CO2 annually")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color(red:0, green: 0.3, blue:0))
                    }
                    Spacer()
                }
                .padding()
                .background(Color.mint.opacity(0.2))
                .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text("Your breakdown:")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        .padding(.bottom, 5)
                    
                    ForEach(["Commute", "Flying", "Diet", "Home Energy"], id: \.self) { area in
                        HStack {
                            Text(area)
                                .foregroundColor(Color.black)
                            Spacer()
                            HStack {
                                ForEach(0..<3, id: \.self) { index in
                                    CategoryIndicator(color: self.indicatorColor(for: area, at: index))
                                    
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.green)
                        Text("Consider improving your EcoHabits in the areas marked.")
                            .font(.headline)
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.mint.opacity(0.1))
                    .cornerRadius(15)
                }
            }
            .padding()
        }
        .navigationBarTitle("Results", displayMode: .inline)
    }
    private func indicatorColor(for area: String, at index: Int) -> Color {
        let score = result.improvementAreas[area] ?? 0
        switch score {
        case 3 where index < 1:
            return .green
        case 2 where index < 2:
            return .yellow
        case 1 where index < 3:
            return .red
        default:
            return .gray
        }
    }
    
    struct CategoryIndicator: View {
        var color: Color
        
        var body: some View {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
        }
    }
}
