//
//  RegAuthViewModel.swift
//  VPN
//
//  Created by Эвелина Пенькова on 14.06.2024.
//

import Foundation
import Firebase
import GoogleSignIn
import FirebaseCore
import CryptoKit
import AuthenticationServices

class RegAuthViewModel: ObservableObject {
    @Published  var email = ""
    @Published  var password = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    var shouldShowMainView = UserDefaults.standard.bool(forKey: "shouldShowMainView")
    @Published var showMainView = false
    @Published var nonce: String?
 
    func loginUser() {
        FirebaseManager.shareds.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                let errorMessage = NSLocalizedString("FailedToLoginUser", comment: "Error of Sign Ip")
                self.alertMessage = "\(errorMessage): \(err.localizedDescription)"
                self.showAlert = true
                return
            }
            
            guard let user = result?.user else { return }
            if user.isEmailVerified {
                self.showMainView = true
                self.shouldShowMainView = true
                UserDefaults.standard.set(self.shouldShowMainView, forKey: "shouldShowMainView")
                print("Successfully logged in as user: \(result?.user.uid ?? "")")
            } else {
                print("Email not verified.")
                self.loginStatusMessage = "Please verify your email before logging in."
                let message = NSLocalizedString("plsFerify", comment: "need to verify)
                self.alertMessage = "\(message)"
                self.showAlert = true
            }
        }
    }
    
     var loginStatusMessage = ""
    
    func createNewAccount() {
        FirebaseManager.shareds.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                let errorMessage = NSLocalizedString("errReg", comment: "Error of Sign Up")
                self.alertMessage = "\(errorMessage): \(err.localizedDescription)"
                self.showAlert = true
                return
                
            }
            
            guard let user = result?.user else { return }
            user.sendEmailVerification { error in
                if let error = error {
                    print("Error sending email verification: \(error.localizedDescription)")
                    return
                }
                print("Verification email sent.")
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            self.alertMessage = "Регистрация успешна! Письмо для подтверждения электронной почты было отправлено. Пожалуйста, проверьте ваш почтовый ящик, включая папку 'Спам'."
            self.showAlert = true
        }
    }

    
    func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
// login with Apple ID
    func loginWithFirebase(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
              guard let nonce else {
                  alertMessage = "Cannot process your request"
                  return
              }
              guard let appleIDToken = appleIDCredential.identityToken else {
                  alertMessage = "Cannot process your request"
                  return
              }
              guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                  alertMessage = "Cannot process your request"
                  return
              }
              // Initialize a Firebase credential, including the user's full name.
              let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                                rawNonce: nonce,
                                                                fullName: appleIDCredential.fullName)
              // Sign in with Firebase.
              Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                  // Error. If error.code == .MissingOrInvalidNonce, make sure
                  // you're sending the SHA256-hashed nonce as a hex string with
                  // your request to Apple.
                    self.alertMessage = "\(error.localizedDescription)"
                  return
                }
                // User is signed in to Firebase with Apple.
                // ...
                  self.showMainView = true
                  
                  self.shouldShowMainView = true
                  
                  UserDefaults.standard.set(self.shouldShowMainView, forKey: "shouldShowMainView")
              }
            }
    }
}
