//
//  SettingsView.swift
//  VPN
//
//  Created by Эвелина Пенькова on 14.06.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var vm = MainViewModel()
    @State private var shouldShowLogOutOptions = false
    @State private var shouldShowDeleteOptions = false
    @State private var showRegAuthView = false
    @State var shouldShowMainView = UserDefaults.standard.bool(forKey: "shouldShowMainView")
    
    var body: some View {
        VStack {
            Form {
                
                Button(action: {
                        openSettings()
                    }) {
                        Text("ChangeLanguage")
                    }
                
                Section("Documents"){
                    NavigationLink(destination: TermsOfServiceView()) {
                        Text("TermsOfService")
                    }
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("PrivacyPolicy")
                    }
                }
                
                Section ("Manage"){
                    
                    Button {
                        shouldShowDeleteOptions.toggle()
                    } label: {
                        Text("DeleteAccount")
                    }
                    
                    Button {
                        shouldShowLogOutOptions.toggle()
                    } label: {
                        Text("signOut")
                    }
                }
                
            }
        }.actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("exit"), message: Text("exitQest"), buttons: [
                .destructive(Text("signOut"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                    shouldShowMainView = false
                    UserDefaults.standard.set(shouldShowMainView, forKey: "shouldShowMainView")
                    
                    showRegAuthView.toggle()
                }),
                .cancel(Text("cancel"))
            ])
        }
        .actionSheet(isPresented: $shouldShowDeleteOptions) {
            .init(title: Text("delete"), message: Text("deleteQest"), buttons: [
                .destructive(Text("DeleteAccount"), action: {
                    print("delete account")
                    vm.deleteUser()
                    shouldShowMainView = false
                    UserDefaults.standard.set(shouldShowMainView, forKey: "shouldShowMainView")
                    
                    showRegAuthView.toggle()
                }),
                .cancel(Text("cancel"))
            ])
        }
        .fullScreenCover(isPresented: $showRegAuthView, onDismiss: nil) {
            RegAuthView()
        }
            .onAppear {
                vm.fetchCurrentUserEmail()
            }
            .navigationTitle("settings")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
    }
    
    func openSettings() {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
}

#Preview {
    SettingsView()
}
