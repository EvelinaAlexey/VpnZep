//
//  Models.swift
//  VpnFly
//
//  Created by Эвелина Пенькова on 15.06.2024.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var uid, email : String
}

struct FirebaseConstants {
    static let email = "email"
    static let passeord = "password"
    static let uid = "uid"
    static let users = "users"
}

struct RoundedCornerShape: Shape { // 1
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path { // 2
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct Country {
    let id = UUID()
        let name: String
        let flag: Image
    }

    extension Country: Equatable {
        static func == (lhs: Country, rhs: Country) -> Bool {
            return lhs.id == rhs.id // Сравниваем страны по их идентификатору
        }
}

struct TwistedLine: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 28, height: 3)
            .background(
            LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 0.76, green: 0, blue: 1), location: 0.09),
            Gradient.Stop(color: Color(red: 0.53, green: 0.19, blue: 0.85).opacity(0.66), location: 0.98),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
            )
            )
            .cornerRadius(9)
    }
}
