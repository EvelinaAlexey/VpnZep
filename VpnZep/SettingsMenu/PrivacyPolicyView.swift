//
//  PrivacyPolicyView.swift
//  something
//
//  Created by EvelinaAlexey on 20.06.2024.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Privacy Policy for VPN Zephyr (VPN Zep)")
                        .font(.title)
                        .bold()
                    
                    Text("Last updated: June 20, 2024")
                        .italic()
                    
                    Text("VPN Zephyr (hereinafter \"Service\", \"we\", \"us\", or \"our\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and protect your personal information when you use our Service.")
                    
                    Section(header: Text("1. Information We Collect").font(.headline)) {
                        Text("""
                        When you use our Service, we may collect the following types of information:
                        
                        - **Personal Information**: Information you provide during registration, such as your name, email address, and payment details.
                        - **Usage Information**: Information about how you use the Service, including your IP address, browser type, and activity logs.
                        - **Device Information**: Information about the device you use to access the Service, such as device type, operating system, and unique device identifiers.
                        """)
                    }
                    
                    Section(header: Text("2. How We Use Your Information").font(.headline)) {
                        Text("""
                        We use the information we collect for the following purposes:
                        
                        - **To Provide and Improve the Service**: To operate and maintain the Service, and to improve its functionality and features.
                        - **To Communicate with You**: To send you updates, notifications, and other information related to the Service.
                        - **To Ensure Security**: To detect and prevent fraud, abuse, or other malicious activities.
                        - **To Comply with Legal Obligations**: To comply with applicable laws, regulations, and legal processes.
                        """)
                    }
                    
                    Section(header: Text("3. How We Protect Your Information").font(.headline)) {
                        Text("""
                        We take the security of your information seriously and implement various measures to protect it, including:
                        
                        - **Encryption**: We use encryption to protect your data during transmission and storage.
                        - **Access Controls**: We restrict access to your information to authorized personnel only.
                        - **Regular Audits**: We conduct regular audits to identify and address potential security vulnerabilities.
                        """)
                    }
                    
                    Section(header: Text("4. Sharing Your Information").font(.headline)) {
                        Text("""
                        We do not sell, trade, or otherwise transfer your personal information to outside parties, except in the following circumstances:
                        
                        - **Service Providers**: We may share your information with trusted service providers who assist us in operating the Service, provided they agree to keep your information confidential.
                        - **Legal Requirements**: We may disclose your information if required to do so by law or in response to valid requests by public authorities.
                        - **Business Transfers**: In the event of a merger, acquisition, or sale of assets, your information may be transferred as part of the transaction.
                        """)
                    }
                    
                    Section(header: Text("5. Your Rights").font(.headline)) {
                        Text("""
                        You have the following rights regarding your personal information:
                        
                        - **Access and Correction**: You have the right to access and correct your personal information.
                        - **Deletion**: You have the right to request the deletion of your personal information.
                        - **Objection**: You have the right to object to the processing of your personal information.
                        - **Portability**: You have the right to request a copy of your personal information in a structured, commonly used, and machine-readable format.
                        
                        To exercise these rights, please contact us at evelinaalexey@gmail.com
                        """)
                    }
                    
                    Section(header: Text("6. Cookies and Tracking Technologies").font(.headline)) {
                        Text("""
                        We use cookies and similar tracking technologies to enhance your experience with the Service. You can manage your cookie preferences through your browser settings.
                        """)
                    }
                    
                    Section(header: Text("7. Changes to This Privacy Policy").font(.headline)) {
                        Text("""
                        We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the \"Last updated\" date. Your continued use of the Service after any changes signifies your acceptance of the new Privacy Policy.
                        """)
                    }
                    
                    Section(header: Text("8. Contact Us").font(.headline)) {
                        Text("""
                        If you have any questions about this Privacy Policy, please contact us at:
                        
                        Email: evelinaalexey@gmail.com
                        
                        By using VPN Zephyr, you acknowledge that you have read and understood this Privacy Policy and agree to its terms.
                        """)
                    }
                }
                .padding()
            }
        }.preferredColorScheme(.dark)
    }
}

#Preview {
    PrivacyPolicyView()
}
