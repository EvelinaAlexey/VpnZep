//
//  CountryPickerView.swift
//  VpnFly
//
//  Created by Эвелина Пенькова on 15.06.2024.
//

import SwiftUI

struct CountryPickerView: View {
    @Binding var selectedCountry: Country?
    @Binding var showCountryPicker: Bool
    @State private var selectedPage = 0
    
    let countries = [
        Country(name: "UK", flagName: "uk_flag", collection: "configs"),
        Country(name: "France", flagName: "france_flag", collection: "configsFR"),
        Country(name: "UAE", flagName: "uae_flag", collection: "configs"),
        Country(name: "Austria", flagName: "austria_flag", collection: "configs"),
        Country(name: "German", flagName: "german_flag", collection: "configsFR"),
        Country(name: "Netherlands", flagName: "netherlands_flag", collection: "configsFR"),
        Country(name: "USA", flagName:"usa_flag", collection: "configsFR")
        
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            TabView(selection: $selectedPage) {
                ForEach(0..<countries.count/2, id: \.self) { index in
                    HStack(spacing: 20) {
                        ForEach(0..<2, id: \.self) { subIndex in
                            let countryIndex = index * 2 + subIndex
                            if countryIndex < countries.count {
                                Button(action: {
                                       withAnimation(.spring()) {
                                           selectedCountry = countries[countryIndex]
                                           showCountryPicker = false
                                       }
                                   }) {
                                    VStack {
                                        ZStack {
                                            
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 132, height: 132)
                                                .overlay(
                                                    countries[countryIndex].flag
                                                        .resizable()
                                                        .scaledToFit()
                                                )
                                                .cornerRadius(65)
                                            Circle()
                                                .fill(Color(red: 0, green: 0, blue: 0)).opacity(0.46)
                                                .frame(width: 132, height: 132)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: 2) // Белая обводка
                                                )
                                                .cornerRadius(65)
                                            Text(countries[countryIndex].name)
                                                .font(.system(size: 19, weight: .bold))
                                                .italic()
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 150) // Set a fixed height for the TabView to avoid expanding

            HStack(spacing: 8) {
                ForEach(0..<countries.count/2, id: \.self) { index in
                    Circle()
                        .fill(index == selectedPage ? Color.pink : Color.gray)
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.top, 10) // Add padding to position the dots properly
        }
        .padding(.bottom, 10) // Add bottom padding to ensure the whole component is centered vertically
    }
}



