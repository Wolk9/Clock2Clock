//
//  User.swift
//  Clock2Clock
//
//  Created by Macbook  on 28/08/2023.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let fullName: String
    let email: String
    let contractDate: String
    let dob: String
    let hoursPerWeek: Int
    let role: String
    

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}


