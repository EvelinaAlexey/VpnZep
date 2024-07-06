//
//  PremiumPageView.swift
//  VpnZep
//
//  Created by EvelinaAlexey on 24.06.2024.
//

import SwiftUI

struct PremiumPageView: View {
    var body: some View {
        ZStack{
            Image("back")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            VStack{
                VStack{
                    Text("Premium")
                        .font(.system(size: 36, weight: .regular))
                        .foregroundColor(.white)
                    Text("dontMiss")
                        .font(.system(size: 25, weight: .thin))
                        .foregroundColor(.white)
                   // Spacer()
                    
                }
                //.padding(.top)
              //  .padding(.top)
                
                benefitsCarouselView()
                
                HStack{
                    PriceCardView(discount: "15", period: Text("perHalfYear"), discountedPrice: Text("priceHalfYear"))
                    PriceCardView(discount: "20", period: Text("perYear"), discountedPrice: Text("priceYear"))
                    PriceCardView(discount: "0", period: Text("perMonth"), discountedPrice: Text("priceMonth"))
                }.padding(.top)
            }
            
        }
    }
}

#Preview {
    PremiumPageView()
}
