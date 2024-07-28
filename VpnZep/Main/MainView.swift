//
//  MainView.swift
//  VPN
//
//  Created by Эвелина Пенькова on 12.06.2024.
//

import SwiftUI
import YandexMobileAds
import UIKit
import NetworkExtension


struct MainView: View {
    @ObservedObject var vm = MainViewModel()
    @ObservedObject var configVm = ConfigsManager()
    // @ObservedObject var adManager = AdManager()

    @State private var showAds = false
    @State private var showUnlock = false
    @State private var didUnlock = false
    @State private var showLoading = false
    @State private var selectedCountry: Country? {
        didSet {
            configVm.country = selectedCountry
        }
    }
    @State private var showSelectedCountry = UserDefaults.standard.value(forKey: "showSelectedCountry")
    @State private var showCountryPicker = false
    @State private var showSettingsMenu = false
    @State private var petCount = 0
    @ObservedObject private var vpnManager = VpnManager()
    @State private var availible = true
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                Image("back")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                                    VStack {
                                        Image(systemName: "text.alignleft")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color(red: 0.68, green: 0, blue: 1))
                                    }
                                }
                                .symbolEffect(.bounce, value: petCount)
                                Spacer()
                            }.padding(.bottom)
                                .padding(.leading, 30)
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
                                    }.disabled(availible == false)
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

                            VStack {
                                if vpnManager.vpnStatus == .disconnected {
                                    SwipeToUnlockView()
                                        .onSwipeSuccess {
                                            withAnimation(.spring()) {
                                                self.didUnlock = true
                                                self.showUnlock = false
                                            }
                                            showLoading = true

                                            configVm.fetchConfForCurrentUser() { result in
                                                switch result {
                                                case .success(let conf):
                                                    print("Получена случайная строка conf:")
                                                    print(conf)
                                                    vpnManager.formatConfigString(conf)
                                                    vpnManager.turnOnTunnel { bool in
                                                        print(bool)
                                                    }
                                                case .failure(let error):
                                                    print("Ошибка: \(error.localizedDescription)")
                                                }
                                            }

                                            availible = false
                                            showLoading = false
                                        }
                                        .transition(AnyTransition.scale.animation(Animation.spring(response: 0.3, dampingFraction: 0.5)))
                                } else {
                                    Button {
                                        withAnimation(.spring()) {
                                            vpnManager.turnOffTunnel()
                                            availible = true
                                        }
                                    } label: {
                                        Text("Disconnect")
                                            .font(.system(size: 19, weight: .medium))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 14)
                                            .padding(.horizontal)
                                            .background(
                                                LinearGradient(
                                                    stops: [
                                                        Gradient.Stop(color: Color(red: 0.49, green: 0, blue: 0.44), location: 0),
                                                        Gradient.Stop(color: Color(red: 0.55, green: 0.55, blue: 0.55).opacity(0.68), location: 0.56),
                                                        Gradient.Stop(color: Color(red: 0.47, green: 0.47, blue: 0.47).opacity(0.36), location: 0.95),
                                                    ],
                                                    startPoint: UnitPoint(x: 0.5, y: -0.91),
                                                    endPoint: UnitPoint(x: 0.5, y: 3.36)
                                                )
                                            )
                                            .cornerRadius(26)
                                            .shadow(color: Color(red: 0, green: 0, blue: 0).opacity(0.25), radius: 2, x: 4, y: 8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 26)
                                                    .inset(by: -0.5)
                                                    .stroke(Color(red: 0.3, green: 0.14, blue: 0.57), lineWidth: 1)
                                            )
                                    }.transition(AnyTransition.scale.animation(Animation.spring(response: 0.3, dampingFraction: 0.5)))
                                }
                            }.padding(.top)

                        }
                        .padding(.bottom)
                        .animation(.default, value: showLoading)
                        .onAppear {
                            vm.fetchCurrentUserEmail()
                            vm.checkEmailVerification()
                            loadSelectedCountry()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - (showSettingsMenu ? 240 : 0))
                    .offset(x: showSettingsMenu ? 130 : 0)
                }
                .onChange(of: selectedCountry) { newCountry in
                    saveSelectedCountry(newCountry)
                    if newCountry != nil {
                        selectedCountry = newCountry
                        showUnlock = true
                    } else {
                        showUnlock = false
                    }
                }
            }.padding(.top)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        showSettingsMenu = false
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
        }
    }

    private func saveSelectedCountry(_ country: Country?) {
        if let country = country {
            let data = try? JSONEncoder().encode(country)
            UserDefaults.standard.set(data, forKey: "selectedCountry")
        } else {
            UserDefaults.standard.removeObject(forKey: "selectedCountry")
        }
    }

    private func loadSelectedCountry() {
        if let data = UserDefaults.standard.data(forKey: "selectedCountry"),
           let country = try? JSONDecoder().decode(Country.self, from: data) {
            self.selectedCountry = country
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
