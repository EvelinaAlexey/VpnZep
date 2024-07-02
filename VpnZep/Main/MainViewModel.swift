//
//  MainViewModel.swift
//  VPN
//
//  Created by Эвелина Пенькова on 12.06.2024.
//

import Foundation
import YandexMobileAds
import SwiftUI

class MainViewModel: ObservableObject{
    @Published var errorMessage = ""
    @Published var user: User?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    @Published var emailVerificationStatus: String = ""
    @Published var userEmail: String?
    
    init() {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shareds.auth.currentUser == nil
            fetchCurrentUser()
            fetchCurrentUserEmail()
        }

    
    func fetchCurrentUserEmail() {
        if let currentUser = FirebaseManager.shareds.auth.currentUser {
            self.userEmail = currentUser.email
        }
    }
    

    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shareds.auth.currentUser?.uid else {
            self.isUserCurrentlyLoggedOut = true
            return
        }

        FirebaseManager.shareds.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user:", error)
                self.isUserCurrentlyLoggedOut = true
                return
            }

            guard let data = snapshot?.data() else {
                self.isUserCurrentlyLoggedOut = true
                return
            }

            self.user = try? snapshot?.data(as: User.self)
            self.isUserCurrentlyLoggedOut = false
        }
    }
    func handleSignOut() {
        isLoading = true // Начало процесса выхода

        do {
            try FirebaseManager.shareds.auth.signOut()
            print("Successfully signed out.")
            DispatchQueue.main.async {
                self.isUserCurrentlyLoggedOut = true
                self.isLoading = false // Конец процесса выхода
            }
        } catch let signOutError {
            print("Error signing out: \(signOutError.localizedDescription)")
            isLoading = false // Если произошла ошибка, обновляем состояние загрузки
        }
    }
    
    func checkEmailVerification() {
            guard let user = FirebaseManager.shareds.auth.currentUser else { return }
            user.reload { error in
                if let error = error {
                    print("Error reloading user: \(error.localizedDescription)")
                    self.emailVerificationStatus = "Error reloading user"
                    return
                }

                if user.isEmailVerified {
                    print("Email is verified")
                    self.emailVerificationStatus = "Все ок"
                } else {
                    print("Email is not verified")
                    self.emailVerificationStatus = "Подтвердите email"
                }
            }
        }
    
    func deleteUser() {
        let user = FirebaseManager.shareds.auth.currentUser
            
            user?.delete { error in
                if let error = error {
                    // Handle error (e.g., show an alert to the user)
                    print("Error deleting user: \(error.localizedDescription)")
                } else {
                    // User deleted successfully
                    print("User deleted successfully")
                    // Optionally, navigate back to the login screen or show a confirmation message
                }
            }
        }

}

