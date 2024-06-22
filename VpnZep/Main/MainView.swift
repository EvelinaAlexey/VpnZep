//
//  MainView.swift
//  VPN
//
//  Created by Эвелина Пенькова on 12.06.2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var vm = MainViewModel()
    @State private var showUnlock = false
    @State private var didUnlock = false
    @State var showLoading = false
    @State private var selectedCountry: Country?
    @State private var showCountryPicker = false
    @State private var showSettingsMenu = false
    @State private var petCount = 0
    
    var body: some View {
        NavigationView {
            ZStack {
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
                
                HStack(spacing: 0) {
                    if showSettingsMenu {
                        SettingsMenuView(showSettingsMenu: $showSettingsMenu)
                            .frame(width: 240)
                            .background(Color.white)
                            .transition(.move(edge: .leading))
                    }
                    
                    ZStack {
                        VStack(spacing: 10) {
                            HStack {
                                Button {
                                    withAnimation {
                                        showSettingsMenu.toggle()
                                    }
                                    petCount += 1
                                } label: {
                                    VStack{
                                        Image(systemName: "text.alignleft")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color(red: 0.68, green: 0, blue: 1))
                                    }
                                }
                                .symbolEffect(.bounce, value: petCount)
                                Spacer()
                            }
                            .padding(.leading, 30)
                            .padding(.top, 40)
                            .offset(x: showSettingsMenu ? -130 : 0)
                            ZStack {
                                Ellipse()
                                    .frame(width: 253, height: 253)
                                    .background(Color(red: 1, green: 1, blue: 1)).opacity(0.23)
                                    .blur(radius: 93.2)
                                Image("WingsVpn")
                                    .resizable()
                                    .frame(width: 390, height: 316)
                                Text("ZEP")
                                    .font(.custom("BungeeHairline-Regular", size: 122))
                                    .foregroundColor(.white)
                            }
                            
                            VStack {
                                if !showCountryPicker {
                                    Button(action: {
                                        withAnimation {
                                            showCountryPicker.toggle()
                                        }
                                    }) {
                                        if let selectedCountry = selectedCountry {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 132, height: 132)
                                                    .overlay(
                                                        selectedCountry.flag
                                                            .resizable()
                                                            .scaledToFit()
                                                    )
                                                    .cornerRadius(65)
                                                Circle()
                                                    .fill(Color(red: 0, green: 0, blue: 0)).opacity(0.46)
                                                    .frame(width: 132, height: 132)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.white, lineWidth: 2)
                                                    )
                                                    .cornerRadius(65)
                                                Text("\(selectedCountry.name)")
                                                    .font(.system(size: 19, weight: .bold))
                                                    .italic()
                                                    .foregroundColor(.white)
                                            }
                                        } else {
                                            
                                                Circle()
                                                    .fill(Color(red: 0, green: 0, blue: 0)).opacity(0.46)
                                                    .frame(width: 132, height: 132)
                                                    .overlay(
                                                        Text("chooseCountry")
                                                            .font(.system(size: 19, weight: .bold))
                                                            .foregroundColor(.white)
                                                    )
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.white, lineWidth: 1)
                                                    )
                                                
                                            
                                        }
                                    }
                                }
                                
                                if showCountryPicker {
                                    CountryPickerView(selectedCountry: $selectedCountry, showCountryPicker: $showCountryPicker)
                                        .frame(width: 347, height: 209)
                                        .background(Color(red: 0.35, green: 0.26, blue: 0.49))
                                        .cornerRadius(20)
                                        .shadow(radius: 10)
                                        .transition(.asymmetric(insertion: .scale, removal: .scale(scale: 0.1)))
                                        .zIndex(1)
                                }
                            }
                            .padding()
                            .animation(.easeInOut, value: showCountryPicker)
                            
                            if showUnlock {
                                SwipeToUnlockView()
                                    .onSwipeSuccess {
                                        self.didUnlock = true
                                        self.showUnlock = false
                                        showLoading = true
                                    }
                                    .transition(AnyTransition.scale.animation(Animation.spring(response: 0.3, dampingFraction: 0.5)))
                            }
                            
                            Button {
                                showLoading = false
                            } label: {
                                Text("stop Loading")
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top, 20)
                            
                            Button {
                                //didChooseCountry = false
                            } label: {
                                Text("off")
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top, 20)
                            
                            if showLoading { LoadingView() }
                        }
                        .animation(.default, value: showLoading)
                        .onAppear {
                            vm.fetchCurrentUserEmail()
                            vm.checkEmailVerification()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - (showSettingsMenu ? 240 : 0))
                    .offset(x: showSettingsMenu ? 130 : 0)
                }
                .onChange(of: selectedCountry) { newCountry in
                    if newCountry != nil {
                        showUnlock = true
                    } else {
                        showUnlock = false
                    }
                }
            }.contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        showSettingsMenu = false
                    }
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
