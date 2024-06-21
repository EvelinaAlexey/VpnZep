//
//  AppDelegate.swift
//  VPN
//
//  Created by Эвелина Пенькова on 12.06.2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import UserNotifications
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    

}
