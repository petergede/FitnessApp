//
//  StadiumContent.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 27/4/24.
//

import SwiftUI

struct StadiumContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var iconSettings: IconNames

    @State private var showingSettingsView = false
    @State private var showingAddPointView = false

    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.locations) { location in
                        NavigationLink(destination: EditLocationView(location: location)) {
                            HStack {
                                Circle()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(colorize(associateTag: location.associate))

                                Text(location.name)
                                    .fontWeight(.semibold)

                                Spacer()

                                Text(associateName(for: location.associate))
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .padding(3)
                                    .frame(minWidth: 62)
                                    .overlay(
                                        Capsule().stroke(Color.gray, lineWidth: 0.75)
                                    )
                            }
                            .padding(.vertical, 10)
                        }
                    }
                    .onDelete(perform: deleteLocation)
                }
                .navigationBarTitle("Locations", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(action: {
                        showingSettingsView.toggle()
                    }) {
                        Image(systemName: "paintbrush")
                    }
                    .sheet(isPresented: $showingSettingsView) {
                        SettingsView().environmentObject(iconSettings)
                    }
                )

                if viewModel.locations.isEmpty {
                    EmptyListView()
                }
            }
            .sheet(isPresented: $showingAddPointView, onDismiss: {
                Task { await viewModel.fetchLocations() }
            }) {
                StadiumListView()
                    .environmentObject(viewModel)
            }
            .overlay(
                Button {
                    showingAddPointView.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .background(Circle().fill(Color("ColorBase")))
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16),
                alignment: .bottomTrailing
            )
            .onAppear {
                Task { await viewModel.fetchLocations() }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // ✅ Swipe to delete with Firestore support
    private func deleteLocation(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let location = viewModel.locations[index]
                do {
                    try await viewModel.deleteLocation(location)
                } catch {
                    print("Failed to delete location: \(error.localizedDescription)")
                }
            }
        }
    }

    private func colorize(associateTag: Int) -> Color {
        switch associateTag {
        case 1: return .pink
        case 2: return .green
        case 3: return .blue
        default: return .gray
        }
    }

    private func associateName(for tag: Int) -> String {
        switch tag {
        case 1: return "Yava"
        case 2: return "Fitness Club"
        case 3: return "International Club"
        default: return "Unknown"
        }
    }
}
