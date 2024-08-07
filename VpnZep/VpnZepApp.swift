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
    
    init() {
        //        MobileAds.setUserConsent(true)
        //        MobileAds.initializeSDK()
        //        FirebaseApp.configure()
        
    }
    
    var shouldShowMainView = UserDefaults.standard.bool(forKey: "shouldShowMainView")
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
            WindowGroup {
                if shouldShowMainView {
                    MainView()
//                        .environmentObject(appDelegate.adManager)

                } else {
                    if UserDefaults.standard.welcomeScreenShown {
                        RegAuthView()
//                            .environmentObject(appDelegate.adManager)
                    } else {
                        WelcomeView()
//                            .environmentObject(appDelegate.adManager)
                    }
                }



            }
        }
}




