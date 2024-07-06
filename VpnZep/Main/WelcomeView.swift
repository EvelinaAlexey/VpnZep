//
//  WelcomeView.swift
//  VpnZep
//
//  Created by EvelinaAlexey on 03.07.2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var pulsate = false
    @AppStorage("welcomeScreenShown")
    var welcomeScreenShown = false
       
    @State var shouldShowLoginView = false

    var body: some View {
        ZStack{
            Image("welcomeView")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            VStack{
                Spacer()
                HStack{
                    
                    Image("stars")
                        .scaleEffect(pulsate ? 1.0 : 1.05)
                    Spacer()
                }
                .padding()
                Spacer()
                Spacer()
                Spacer()
                
            }
           
            VStack(spacing: 64) {
                Spacer()
                Spacer()
                Spacer()
                
                Text("welcome")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 333)
                    .multilineTextAlignment(.center)
                    
                Button {
                    UserDefaults.standard.welcomeScreenShown = true
                    shouldShowLoginView.toggle()

                } label: {
                    Text("get")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 274, height: 73)
                        .background(
                        LinearGradient(
                        stops: [
                        Gradient.Stop(color: Color(red: 0, green: 1, blue: 0.76), location: 0),
                        Gradient.Stop(color: Color(red: 0.42, green: 0, blue: 1), location: 1),
                        ],
                        startPoint: UnitPoint(x: 0, y: 0.5),
                        endPoint: UnitPoint(x: 1, y: 0.5)
                        )
                        )
                        .cornerRadius(31)
                        .shadow(color: Color(red: 0, green: 0, blue: 0).opacity(0.25), radius: 8, x: 8, y: 10)
                        .overlay(
                        RoundedRectangle(cornerRadius: 31)
                        .inset(by: 1)
                        .stroke(Color(red: 1, green: 1, blue: 1), lineWidth: 2)
                        )
                        .scaleEffect(pulsate ? 1.1 : 1.0)
                }.fullScreenCover(isPresented: $shouldShowLoginView, onDismiss: nil) {
                    RegAuthView()
                }

                Spacer()
            }
        }.onAppear {
            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                self.pulsate = true
            }
        }
    }
}
extension UserDefaults {
    var welcomeScreenShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "welcomeScreenShown") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "welcomeScreenShown")
        }
    }
}

#Preview {
    WelcomeView()
}
