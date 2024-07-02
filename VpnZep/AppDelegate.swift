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
import YandexMobileAds
import YandexMobileAdsTarget
import YandexMobileAdsInstream

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Инициализация Firebase
        print("Initializing Firebase")
        FirebaseApp.configure()
        print("Firebase initialized")
        
        // Инициализация Yandex Mobile Ads SDK
        print("Initializing Yandex Mobile Ads SDK")
        MobileAds.initializeSDK {
            print("Yandex Mobile Ads SDK initialized")
        }
        
        // Установка делегатов
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // Для iOS 10 отображение уведомлений (отправлено через APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Этот метод вызывается, когда устройство успешно регистрируется для удаленных уведомлений (push-уведомлений).
        // Можно передать токен в Firebase или другой сервер уведомлений.
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Этот метод вызывается, когда устройство не может зарегистрироваться для удаленных уведомлений.
        // Можно обработать ошибку регистрации здесь.
        print("Failed to register for remote notifications with error: \(error)")
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let deviceToken: [String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // Этот токен можно использовать для тестирования уведомлений на FCM
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {

    // Получение отображаемых уведомлений для устройств iOS 10.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        // Измените это на предпочтительный вариант представления
        completionHandler([[.banner, .badge, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID from userNotificationCenter didReceive: \(messageID)")
        }

        print(userInfo)

        completionHandler()
    }
}

