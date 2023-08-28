//
//  AuthViewModel.swift
//  Clock2Clock
//
//  Created by Macbook  on 28/08/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isEditProfileViewOpen: Bool = false
    @EnvironmentObject var errorModel: ErrorHandlingModel
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String, errorHandler: ErrorHandlingModel) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG singIn: failed to login user with error \(error.localizedDescription)")
            errorHandler.handle(error: error)
        }
    }
    
    func createUser(withEmail email: String, password: String, firstName: String, lastName: String, fullName: String, dob: String, contractDate: String, hoursPerWeek: Int, role: String, errorHandler: ErrorHandlingModel) async {
        print("Create User")
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let fullName = "\(firstName) \(lastName)"
            let user = User(id: result.user.uid,
                            firstName: firstName,
                            lastName: lastName,
                            fullName: fullName,
                            email: email,
                            contractDate: contractDate,
                            dob: dob,
                            hoursPerWeek: 0,
                            role: role
            )
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("C2CUsers").document(user.id).setData(encodedUser)
            
            // C2CUsers is tijdelijk. users moet het worden
            // De velden die in een profiel worden aangemaakt in cico moeten hier worden overgenomen.
            
            await fetchUser() // laadt de net aangemaakte data
            
        } catch {
            print("Debug: failed to create user with error \(error.localizedDescription)")
            errorHandler.handle(error: error)
        }
        
    }
    
    func singOut() {
    let errorHandler = ErrorHandlingModel()
        do {
            try Auth.auth().signOut() //Sign Out
            self.userSession = nil  //take back to loginscreen
            self.currentUser = nil  //wipes out current User data model
        } catch {
            print("DEBUG: Faild to sign out with error \(error.localizedDescription)")
            errorHandler.handle(error: error)
        }
        
    }
    
    func deleteAccount() async {
//        let errorHandler = ErrorHandlingModel()
//        do {
//            guard let uid = Auth.auth().currentUser?.uid else { return }
//            try await Firestore.firestore().collection("C2CUsers").document(uid).delete()
//        } catch {
//            errorHandler.handle(error: error)
//        }
//        
//        do {
//            guard let user = Auth.auth().currentUser
//                    user?.delete { error in
//                        
//                    }
//            
//        } catch {
//            errorHandler.handle(error: <#T##Error#>)
//        }
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("C2CUsers").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)

    }
}
