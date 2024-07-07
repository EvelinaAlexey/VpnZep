//
//  PriceCardView.swift
//  VpnZep
//
//  Created by EvelinaAlexey on 06.07.2024.
//


import SwiftUI

struct PriceCardView: View {
    var discount: String
    var period: Text
    var discountedPrice: Text
    
    init(discount: String, period: Text, discountedPrice: Text) {
        self.discount = discount
        self.period = period
        self.discountedPrice = discountedPrice
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 111, height: 183)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0, green: 0.06, blue: 0.56), location: 0),
                            Gradient.Stop(color: Color(red: 0.45, green: 0.95, blue: 0.88).opacity(0.99), location: 1),
                        ],
                        startPoint: UnitPoint(x: 0.95, y: -0.07),
                        endPoint: UnitPoint(x: -0.05, y: 1.09)
                    )
                )
                .cornerRadius(26)
            VStack {
                VStack(alignment: .leading, spacing: -10) {
        HStack(spacing: 0){
            Text(discount)
                .font(.system(size: 50, weight: .bold))
                .italic()
                .foregroundColor(Color(red: 0, green: 1, blue: 0.93))
                
            Text("%")
                .font(.system(size: 24, weight: .bold))
                .italic()
                .foregroundColor(Color(red: 0, green: 1, blue: 0.93))
                .baselineOffset(15) // Смещение для выравнивания процента
        }
              Text("discount")
                        .font(.system(size: 20, weight: .bold))
                        .italic()
                        .foregroundColor(Color(red: 0, green: 1, blue: 0.93))
                }
                
                .padding(.bottom, 10)
                
               // Spacer()
                
                VStack(spacing: 0) {
                    
                discountedPrice
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    period
                        .font(.system(size: 12, weight: .thin))
                        .foregroundColor(.white)
                    
                }
                //.padding(.bottom, 10)
            }
            .padding()
        }
            
    }
}

//#Preview {
//    PriceCardView(discount: "20", period: Text("perYear"), discountedPrice: Text("priceYear"))
//}
