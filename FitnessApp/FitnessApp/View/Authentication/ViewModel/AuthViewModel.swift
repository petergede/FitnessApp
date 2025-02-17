//
//  AuthViewModel.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 17/2/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol{
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var authErrorMessage: String?
    
    init() {
        //keep me logged in
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        self.userSession = result.user
        await fetchUser()
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.userSession = result.user
        let user = User(id: result.user.uid, fullname: fullname, email: email)
        let encodedUser = try Firestore.Encoder().encode(user)
        try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        await fetchUser()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() //signs out user on backend
            self.userSession = nil //wipes out user session and takes us back to login screen
            self.currentUser = nil //wipes out current user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        
    }
    
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser else { return }
        guard let uid = user.uid as String? else { return }

        do {
            // 1. Delete user data from Firestore
            try await Firestore.firestore().collection("users").document(uid).delete()

            // 2. Delete user from Firebase Authentication
            try await user.delete()

            // 3. Clear local session and user data
            self.userSession = nil
            self.currentUser = nil

            print("DEBUG: Account successfully deleted.")
        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
    }
}
