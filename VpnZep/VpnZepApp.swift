//
//  VpnZepApp.swift
//  VpnZep
//
//  Created by EvelinaAlexey on 20.06.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import UserNotifications

@main
struct VpnZepApp: App {
    var shouldShowMainView = UserDefaults.standard.bool(forKey: "shouldShowMainView")
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        

    
    var body: some Scene {
            WindowGroup {
                if shouldShowMainView {
                                MainView()
                } else {
                    if UserDefaults.standard.welcomeScreenShown {
                        RegAuthView()
                    } else {
                        WelcomeView()
                    }
                }

            }
        }
}




