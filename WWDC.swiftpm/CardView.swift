import SwiftUI

// MARK: - Card View
struct CardView: View {
    var cardText: String
    var cardImage: String
    var cardDescription: String
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sharedData: SharedData
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding(.leading, -10)
                .padding(.top, -10)
                
                Spacer()
            }
            
            Image(cardImage)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text(cardText)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(cardDescription)
                .padding()
            
            Button("Log") {
                sharedData.points += 50
                dismiss()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.mint)
            .cornerRadius(10)
            .bold()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
        .padding(.horizontal, 20)
    }
}
