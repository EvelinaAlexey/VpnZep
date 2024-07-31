//
//  ContentView.swift
//  something
//
//  Created by EvelinaAlexey on 20.06.2024.
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        VStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Terms of Service for VPN Zephyr (VPN Zep)")
                        .font(.title)
                        .bold()
                    
                    Text("Last updated: June 20, 2024")
                        .italic()
                    
                    Text("Welcome to VPN Zephyr (VPN Zep). By using our service, you agree to comply with the following terms of service. Please read them carefully before using our service.")
                    
                    Section(header: Text("1. Acceptance of Terms").font(.headline)) {
                        Text("These terms of service (hereinafter \"Terms\") govern your use of VPN Zephyr (hereinafter \"Service\"). By using the Service, you agree to these Terms. If you do not agree to these Terms, do not use the Service.")
                    }
                    
                    Section(header: Text("2. Description of Service").font(.headline)) {
                        Text("VPN Zephyr provides virtual private network (VPN) services, ensuring anonymity and security for your internet connection.")
                    }
                    
                    Section(header: Text("3. Registration and Account").font(.headline)) {
                        Text("To use the Service, you may need to register an account. You agree to provide accurate and up-to-date information during registration. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.")
                    }
                    
                    Section(header: Text("4. Privacy").font(.headline)) {
                        Text("We care about your privacy. Please review our Privacy Policy to understand how we collect, use, and protect your personal information.")
                    }
                    
                    Section(header: Text("5. Use of Service").font(.headline)) {
                        Text("""
                           You agree to use the Service only for lawful purposes and in accordance with these Terms. Prohibited uses include, but are not limited to:
                           
                           - Illegal activities;
                           - Distribution of malware or viruses;
                           - Infringement of intellectual property rights;
                           - Accessing prohibited content;
                           - Mass mailings (spam);
                           - Any other activities that may harm or disrupt the Service.
                           """)
                    }
                    
                    Section(header: Text("6. Limitation of Liability").font(.headline)) {
                        Text("The Service is provided \"as is\" and \"as available.\" We do not guarantee uninterrupted or error-free operation of the Service. We are not liable for any direct or indirect damages arising from the use or inability to use the Service.")
                    }
                    
                    Section(header: Text("7. Changes to Terms").font(.headline)) {
                        Text("We reserve the right to modify these Terms at any time. We will notify you of changes by updating the date of the last modification on this page. Continued use of the Service after any changes means you accept the new Terms.")
                    }
                    
                    Section(header: Text("8. Termination of Use").font(.headline)) {
                        Text("We may suspend or terminate your access to the Service at any time without prior notice if you violate these Terms or if we deem it necessary to protect our interests.")
                    }
                    
                    Section(header: Text("9. Governing Law").font(.headline)) {
                        Text("These Terms are governed by and construed in accordance with the laws of the jurisdiction where VPN Zephyr is registered.")
                    }
                    
                    Section(header: Text("10. Contact Information").font(.headline)) {
                        Text("If you have any questions about these Terms, please contact us at: vpnzep@gmail.com")
                    }
                    
                    Text("By using VPN Zephyr, you acknowledge that you have read, understood, and agree to these Terms.")
                }
                .padding()
            }
        }.preferredColorScheme(.dark)
    }
}

#Preview {
    TermsOfServiceView()
}
