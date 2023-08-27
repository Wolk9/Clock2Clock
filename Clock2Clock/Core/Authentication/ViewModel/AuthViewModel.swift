//
//  AuthViewModel.swift
//  Clock2Clock
//
//  Created by Macbook  on 28/08/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign in...")
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        print("Create User")
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("C2CUsers").document(user.id).setData(encodedUser)
            
            // C2CUsers is tijdelijk. users moet het worden
            // De velden die in een profiel worden aangemaakt in cico moeten hier worden overgenomen.
            
            
        } catch {
            print("Debug: failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func singOut() {
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() {
        
    }
}
