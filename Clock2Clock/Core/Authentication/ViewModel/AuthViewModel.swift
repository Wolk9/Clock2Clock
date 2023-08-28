//
//  AuthViewModel.swift
//  Clock2Clock
//
//  Created by Macbook  on 28/08/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Debug: failed to login user with error \(error.localizedDescription)")
        }
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
            
            await fetchUser() // laadt de net aangemaakte data
            
        } catch {
            print("Debug: failed to create user with error \(error.localizedDescription)")
            // showError(error.localizedDescription)
        }
        
    }
    
    func singOut() {
        do {
            try Auth.auth().signOut() //Sign Out
            self.userSession = nil  //take back to loginscreen
            self.currentUser = nil  //wipes out current User data model
        } catch {
            print("DEBUG: Faild to sign out with error \(error.localizedDescription)")
        }
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("C2CUsers").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)

    }
}
