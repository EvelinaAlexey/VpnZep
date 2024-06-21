//
//  SettingsMenuView.swift
//  VpnFly
//
//  Created by Эвелина Пенькова on 17.06.2024.
//

import SwiftUI

struct SettingsMenuView: View {
    @Binding var showSettingsMenu: Bool
    @ObservedObject var vm = MainViewModel()
    @State private var shouldShowLogOutOptions = false
    @State private var showRegAuthView = false
    @State var shouldShowMainView = UserDefaults.standard.bool(forKey: "shouldShowMainView")
    
    var body: some View {
        ZStack {
            LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 0.17, green: 0.04, blue: 0.26), location: 0),
            Gradient.Stop(color: Color(red: 0, green: 0, blue: 0), location: 1),
            ],
            startPoint: UnitPoint(x: 0, y: 0.37),
            endPoint: UnitPoint(x: 2.4, y: 0.37)
            )
            .ignoresSafeArea()
            
            VStack {
                VStack (spacing: 20){
                    HStack{
                        VStack(alignment:.leading) {
                            Text("user:")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .italic()
                            
                            Text("\(vm.userEmail ?? "")")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                            
                        }
                        Spacer()
                    }
                    HStack{
                        Rectangle()
                            .frame(width: 81, height: 1)
                            .foregroundColor(.white)
                        Spacer()
                    }.padding(.leading, -15)
                }
                VStack (spacing: 17) {
                    NavigationLink(destination: SettingsView()){
                        HStack{
                            Image(systemName: "gear")
                                .frame(width: 19, height: 19)
                                .foregroundColor(.white)
                            Text("settings")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    Button{
                        openTg()
                    } label: {
                        HStack{
                            Image(systemName: "figure.wave.circle")
                                .frame(width: 19, height: 19)
                                .foregroundColor(.white)
                            Text("support")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    NavigationLink(destination: DescriptionView()){
                        HStack{
                            Image(systemName: "newspaper.circle")
                                .frame(width: 19, height: 19)
                                .foregroundColor(.white)
                            Text("aboutUs")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                Button {
                    shouldShowLogOutOptions.toggle()
                } label: {
                    HStack{
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .frame(width: 19, height: 19)
                            .foregroundColor(.white)
                        Text("signOut")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            }
                .padding(.top, 20)
                Spacer()
            }.actionSheet(isPresented: $shouldShowLogOutOptions) {
                .init(title: Text("Выход"), message: Text("Уже уходите"), buttons: [
                    .destructive(Text("signOut"), action: {
                        print("handle sign out")
                        vm.handleSignOut()
                        shouldShowMainView = false
                        UserDefaults.standard.set(shouldShowMainView, forKey: "shouldShowMainView")
                        
                        showRegAuthView.toggle()
                    }),
                    .cancel(Text("Остаться"))
                ])
            }
            
            .padding()
        }
            .shadow(color: Color(red: 0, green: 0, blue: 0).opacity(0.25), radius: 20, x: 21, y: 0)
            .fullScreenCover(isPresented: $showRegAuthView, onDismiss: nil) {
                RegAuthView()
            }
                .onAppear {
                    vm.fetchCurrentUserEmail()
                }
    }
    func openTg() {
        if let url = URL(string: "https://t.me/etoevelina") {
            UIApplication.shared.open(url)
        }
    }
}
