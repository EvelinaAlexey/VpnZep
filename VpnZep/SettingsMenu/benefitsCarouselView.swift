//
//  benefitsCarouselView.swift
//  VpnZep
//
//  Created by EvelinaAlexey on 06.07.2024.
//

import SwiftUI

struct benefitsCarouselView: View {
    @State private var selectedPage = 0
      
      let benefits = [
          Benefit(desc: Text("ben4"), cart: Image("no-ads")),
          Benefit(desc: Text("ben3"), cart: Image("instant-connection")),
          Benefit(desc: Text("ben2"), cart: Image("unlimited")),
          Benefit(desc: Text("ben1"), cart: Image("earth"))
      ]
      
      var body: some View {
          VStack {
              TabView(selection: $selectedPage) {
                  ForEach(0..<benefits.count, id: \.self) { index in
                      ZStack {
                          
                              Rectangle()
                                  .foregroundColor(.clear)
                                  .frame(width: 328, height: 377)
                                  .background(
                                  LinearGradient(
                                  stops: [
                                  Gradient.Stop(color: Color(red: 0, green: 1, blue: 0.9).opacity(0.48), location: 0),
                                  Gradient.Stop(color: Color(red: 0.43, green: 0.78, blue: 1).opacity(0.33), location: 1),
                                  ],
                                  startPoint: UnitPoint(x: 0.5, y: 0),
                                  endPoint: UnitPoint(x: 0.5, y: 1)
                                  )
                                  )
                                  .cornerRadius(60)
                                  .shadow(color: Color(red: 0, green: 0, blue: 0).opacity(0.25), radius: 2, x: 12, y: 13)
                                  .overlay(
                                  RoundedRectangle(cornerRadius: 60)
                                  .inset(by: -0.5)
                                  .stroke(Color(red: 1, green: 1, blue: 1).opacity(0.5), lineWidth: 1)
                                  )
                          VStack{
                              benefits[index].cart
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 289, height: 289)
                                  .cornerRadius(60)
                              
                              benefits[index].desc
                                  .font(.system(size: 20, weight: .bold))
                                  .foregroundColor(.white)
                                  .padding(.top, 17)
                              
                              
                          }
                          
                      }

                      .tag(index)
                  }
              }
              .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
              .frame(height: 400) // Set a fixed height for the TabView to avoid expanding

              ZStack {
                  Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 100, height: 32)
                  .background(Color(red: 0.77, green: 0.77, blue: 0.77)).opacity(0.6)
                  .cornerRadius(18)
                  
                  HStack(spacing: 8) {
                          ForEach(0..<benefits.count, id: \.self) { index in
                              ZStack {
                                  Circle()
                                      .fill(Color.gray)
                                      .frame(width: 12, height: 12)
                                  
                                  if index == selectedPage {
                                      Circle()
                                  .fill(
                                      LinearGradient(
                                          gradient: Gradient(stops: [
                                              Gradient.Stop(color: Color(red: 0, green: 1, blue: 0.76), location: 0),
                                              Gradient.Stop(color: Color(red: 0.42, green: 0, blue: 1), location: 1)
                                          ]),
                                          startPoint: UnitPoint(x: 0, y: 0),
                                          endPoint: UnitPoint(x: 1, y: 1)
                                      )
                                  )
                                  .frame(width: 12, height: 12)
                                  }
                              }
                          }
                      }
                  }
              }
             // .padding(.bottom, 10) // Add bottom padding to ensure the whole component is centered vertically
      }
}

//#Preview {
//    benefitsCarouselView()
//}
