//
//  ProfileView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 6/10/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteConfirmation = false

    var body: some View {
        if let user = viewModel.currentUser {
            List {
                // USER INFO + MEMBERSHIP SECTION
                Section {
                    VStack {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)

                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Text(user.isAdmin ? "Admin" : "User")
                                .font(.footnote)
                                .foregroundColor(user.isAdmin ? .red : .gray)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(user.isAdmin ? Color.red.opacity(0.1) : Color.gray.opacity(0.1))
                                .clipShape(Capsule())
                        }
                        .padding(.bottom, 8)

                        // MEMBERSHIP DISPLAY
                        Text("\(user.membership) Membership")
                            .font(.callout) // Nicer, delicate
                            .fontWeight(.medium) // Optional: .thin, .light
                            .foregroundColor(.black) // Black text
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(membershipColor(for: user.membership))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                // GENERAL SECTION
                Section("General") {
                    HStack {
                        SettingsRowView(imageName: "gear",
                                        title: "Version",
                                        tintColor: Color(.white))

                        Spacer()

                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }

                // ACCOUNT SECTION
                Section("Account") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill",
                                        title: "Sign Out",
                                        tintColor: .red)
                    }

                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill",
                                        title: "Delete Account",
                                        tintColor: .red)
                    }
                }
                .alert("Delete Account", isPresented: $showDeleteConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Yes, Delete", role: .destructive) {
                        Task {
                            await viewModel.deleteAccount()
                        }
                    }
                } message: {
                    Text("Are you sure you want to delete your account? This action cannot be undone.")
                }
            }
        }
    }

    // Membership Color Helper Function
    func membershipColor(for membership: String) -> Color {
        switch membership.lowercased() {
        case "basic":
            return .bronze
        case "standard":
            return .gold
        case "premium":
            return .diamond
        default:
            return .gray
        }
    }
}

extension Color {
    static let bronze = Color(red: 205 / 255, green: 127 / 255, blue: 50 / 255)
    static let gold = Color(red: 255 / 255, green: 215 / 255, blue: 0 / 255)
    static let diamond = Color(red: 185 / 255, green: 242 / 255, blue: 255 / 255)
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
