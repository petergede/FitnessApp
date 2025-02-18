//
//  User.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 17/2/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let isAdmin: Bool
    let membership: String

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: UUID().uuidString, fullname: "Petros Gede", email: "test@gmail.com",isAdmin: true,membership: "Basic")
}
