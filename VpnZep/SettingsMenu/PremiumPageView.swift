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
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0, green: 0, blue: 0), location: 0),
                    Gradient.Stop(color: Color(red: 0.44, green: 0, blue: 1), location: 0.55),
                    Gradient.Stop(color: Color(red: 1, green: 1, blue: 1), location: 1),
                ],
                startPoint: UnitPoint(x: 0.5, y: -0.08),
                endPoint: UnitPoint(x: 0.5, y: 1.32)
            )
            .ignoresSafeArea()
            
            VStack (alignment: .leading){
                HStack{
                    Text("dontMiss")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .italic()
                }
                .padding(.leading, 24)
                VStack (alignment: .leading){
                    Group {
                        Text("ben1")

                        Text("ben2")
                            
                        Text("ben3")
                    
                        Text("ben4")
                      
                    }
                    .font(.system(size: 25, weight: .regular))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 0.15, green: 0.1, blue: 0.29))
                    .cornerRadius(42)
                    .overlay(
                        RoundedRectangle(cornerRadius: 42)
                            .inset(by: -1)
                            .stroke(Color(red: 0.68, green: 0, blue: 1), lineWidth: 2)
                        )
                    .padding(.bottom, 12)
                    .padding(.leading, 24)
                }.padding(.top, 10)
                ZStack{
                    HStack{
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 121, height: 85)
                                .background(Color(red: 0, green: 0, blue: 0))
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .inset(by: -0.5)
                                        .stroke(Color(red: 0.91, green: 0, blue: 0.55), lineWidth: 1)
                                )
                            
                            VStack {
                                Text ("priceHalfYear")
                                    .font(.system(size: 27, weight: .bold))
                                    .foregroundColor(.white)
                                    .italic()
                                Text("perHalfYear")
                                    .font(.system(size: 13,weight: .thin))
                                    .foregroundColor(.white)
                            }.padding(.trailing, 15)
                            
                        }.padding(.trailing, 125)
                            .padding(.top, 65)
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 104, height: 57)
                                .background(Color(red: 0, green: 0, blue: 0))
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .inset(by: -0.5)
                                        .stroke(Color(red: 0.91, green: 0, blue: 0.55), lineWidth: 1)
                                )
                            
                            VStack {
                                Text ("priceMonth")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .italic()
                                Text("perMonth")
                                    .font(.system(size: 10,weight: .thin))
                                    .foregroundColor(.white)
                            }
                        }.padding(.top, 65)
                            .padding(.trailing, 25)
                        
                    }
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 168, height: 133)
                            .background(Color(red: 0, green: 0, blue: 0))
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .inset(by: -0.5)
                                    .stroke(Color(red: 0.91, green: 0, blue: 0.55), lineWidth: 1)
                            )
                        VStack {
                            Text ("priceYear")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                                .italic()
                            Text("perYear")
                                .font(.system(size: 22,weight: .thin))
                                .foregroundColor(.white)
                        }
                    }
                }.padding(.top, 20)
                    .padding(.leading, 25)
            }
            
        }
    }
}

#Preview {
    PremiumPageView()
}
