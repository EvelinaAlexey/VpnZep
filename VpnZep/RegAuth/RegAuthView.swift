//
//  RegAuTh.swift
//  VPN
//
//  Created by Эвелина Пенькова on 09.06.2024.
//

import SwiftUI
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import _AuthenticationServices_SwiftUI


struct RegAuthView: View {
    
    @State private var isLoginMode = true
    @FocusState private var isPasswordFocused: Bool
    @ObservedObject var vm = MainViewModel()
    var shouldShowMainView = UserDefaults.standard.bool(forKey: "shouldShowMainView")
    @ObservedObject var raVm = RegAuthViewModel()
    
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
                VStack (spacing: 10){
                    ZStack{
                        Ellipse()
                            .frame(width: 253, height: 253)
                            .background(Color(red: 1, green: 1, blue: 1)).opacity(0.23)
                            .blur(radius: 93.2)
                        Image("WingsVpn")
                            .resizable()
                            .frame(width: 390, height: 316)
                        Text("ZEP")
                            .font(.custom ("BungeeHairline-Regular", size: 122))
                            .foregroundColor(.white)
                    }
                    VStack{
                        Picker(selection: $isLoginMode, label: Text("Picker here")) {
                            Text("signIn")
                                .tag(true)
                            Text("signUp")
                                .tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .opacity(0)
                        
                        Group {
                            TextField("Email", text: $raVm.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .focused($isPasswordFocused, equals: false)
                                .onSubmit {
                                    isPasswordFocused = true
                                }

                            SecureField("pswrd", text: $raVm.password)
                                .focused($isPasswordFocused)
                            
                        }
                        .multilineTextAlignment(.center)
                        .font(.system(size: 21))
                        .foregroundColor(.black)
                        .frame(width: 277, height: 60)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .cornerRadius(22)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .inset(by: -1)
                                .stroke(Color(red: 0.58, green: 0.03, blue: 0.62), lineWidth: 2)
                        )
                        .padding(7)
                        
                        
                        
                        
                        Button {
                            handleAction()
                        } label: {
                            Text(isLoginMode ? "signIn" : "signUp")
                                .foregroundColor(Color(.white))
                                .font(.system(size: 21, weight: .bold))
                                .padding(.horizontal, 50)
                                .padding(.vertical, 15)
                        }
                        .frame(width: 274, height: 55)
                        .background(Color(red: 0.01, green: 0.02, blue: 0.46))
                        .cornerRadius(22)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        
                        //Spacer()
                        HStack{
                            Button {
                                signInWithGoogle()
                            } label: {
                                HStack{
                                    Image("Google")
                                        .resizable()
                                        .frame(width: 31, height: 31)
                                    
                                    Text("Google")
                                        .font(.system(size: 17))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 132, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .background(Color(.black))
                                .cornerRadius(12)
                               
                            }

// Новая кнопка Apple Sign In
                            SignInWithAppleButton(.signIn) { request in
                                let nonce = raVm.randomNonceString()
                                raVm.nonce = nonce
                                request.requestedScopes = [.email, .fullName]
                                request.nonce = raVm.sha256(nonce)
                                
                            } onCompletion: { result in
                                switch result {
                                case .success(let authorization):
                                    raVm.loginWithFirebase(authorization)
                                case .failure(let error):
                                    raVm.alertMessage = "\(error.localizedDescription)"
                                }
                            }
                            .frame(width: 132, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .background(Color(.black))
                            .cornerRadius(12)
                        }
                        .padding(.top, 10)
                        
                        
                        
                        Text("or")
                            .foregroundColor(Color(.white))
                            .font(.system(size: 21, weight: .thin))
                        
                        Button {
                            isLoginMode.toggle()
                        } label: {
                            Text(isLoginMode ? "signUp" : "signIn")
                                .foregroundColor(Color(.white))
                                .font(.system(size: 21, weight: .bold))
                                .underline()
                        }
                        
                    }
                    
                    
                    
                }
            }
            .preferredColorScheme(.light)
            .fullScreenCover(isPresented: $raVm.showMainView, onDismiss: nil) {
                            MainView()
                        }
        }.alert(isPresented: $raVm.showAlert) {
            Alert(title: Text("Уведомление"), message: Text(raVm.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func handleAction() {
       if isLoginMode {
           print("Should log into Firebase with existing credentials")
           raVm.loginUser()
           
       } else {
           raVm.createNewAccount()
           print("Register a new account inside of Firebase Auth and then store image in Storage somehow....")
       }
   }
// login with google acc
    private func signInWithGoogle() {
         guard let clientID = FirebaseApp.app()?.options.clientID else { return }
         
         let config = GIDConfiguration(clientID: clientID)
         GIDSignIn.sharedInstance.configuration = config
         
         GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
             guard error == nil else {
                 return
             }
             
             guard let user = result?.user,
                   let idToken = user.idToken?.tokenString
             else {
                 return
             }
             
             let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
             
            
             
             FirebaseManager.shareds.auth.signIn(with: credential) { result, error in
                 guard error == nil else {
                     return
                 }
                 
             }
             raVm.showMainView = true
             
             raVm.shouldShowMainView = true
             
             UserDefaults.standard.set(raVm.shouldShowMainView, forKey: "shouldShowMainView")

         }
     }

}
        
struct RegAuthView_Previews1: PreviewProvider {
    static var previews: some View {
        RegAuthView()
    }
}
