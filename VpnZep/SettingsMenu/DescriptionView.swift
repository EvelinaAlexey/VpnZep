//
//  DescriptionView.swift
//  VpnFly
//
//  Created by Эвелина Пенькова on 17.06.2024.
//

import SwiftUI

struct DescriptionView: View {
    var body: some View {
        ZStack {
            Image("back")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            VStack{
                VStack{
                    Spacer()
                    ZStack{
                        Ellipse()
                            .frame(width: 253, height: 253)
                            .background(Color(red: 1, green: 1, blue: 1)).opacity(0.23)
                            .blur(radius: 93.2)
                        Image("WingsVpn")
                            .resizable()
                            .frame(width: 390, height: 316)
                        Text("ZEP")
                            .font(.custom ("BungeeHairline-Regular", size: 122))
                            .foregroundColor(.white)
                        
                    }
                    VStack(spacing: 3){
                        Text("VPN Zephyr")
                            .font(.system(size: 36, weight: .ultraLight))
                            .foregroundColor(.white)
                        (Text("version")
                            .font(.system(size: 21, weight: .ultraLight))
                            .foregroundColor(.white))
                        + (Text(" v.1.0")
                            .font(.system(size: 21, weight: .ultraLight))
                            .foregroundColor(.white))
                    }
                    .padding(.top, 5)
                    Spacer()
                    
                    Text("©2024 VPN ZEP")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.white)
                }
                
            }
            
                
        }
        .navigationTitle("aboutUs")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    DescriptionView()
}
