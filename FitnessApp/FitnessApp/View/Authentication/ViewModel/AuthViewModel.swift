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
    @Published var locations: [MapPoint] = []
    
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
    
    func createUser(withEmail email: String, password: String, fullname: String,isAdmin: Bool, membership: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.userSession = result.user
        let user = User(id: result.user.uid, fullname: fullname, email: email,isAdmin: false, membership: membership)
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
    
    func addPoint(name: String, price: Double, information: String, lat: Double, lon: Double, associate: Int) async throws {
        let newLocation = MapPoint(
            name: name,
            price: price,
            information: information,
            lat: lat,
            lon: lon,
            associate: associate
        )

        let db = Firestore.firestore()

        do {
            try await db.collection("locations").document(newLocation.id).setData(from: newLocation)
            print("DEBUG: Location added successfully!")
        } catch {
            print("DEBUG: Failed to add location with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchLocations() async {
        let db = Firestore.firestore()
        do {
            let snapshot = try await db.collection("locations").getDocuments()
            let fetchedLocations = snapshot.documents.compactMap { document in
                try? document.data(as: MapPoint.self)
            }
            DispatchQueue.main.async {
                self.locations = fetchedLocations
            }
        } catch {
            print("DEBUG: Failed to fetch locations: \(error.localizedDescription)")
        }
    }
    
    func updateLocation(_ location: MapPoint) async throws {
        let db = Firestore.firestore()
        try await db.collection("locations").document(location.id).setData(from: location)
    }
    
    func deleteLocation(_ location: MapPoint) async throws {
        let db = Firestore.firestore()
        try await db.collection("locations").document(location.id).delete()
        // Remove locally after deletion
        DispatchQueue.main.async {
            self.locations.removeAll { $0.id == location.id }
        }
    }
}
