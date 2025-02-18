//
//  ListRowItemView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 24/4/24.
//



import SwiftUI

struct StadiumListView: View {
    //PROPERTIES

    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var associate: String = "Yava"
    @State private var price: Double = 0.0
    @State private var longitude: Float = 0
    @State private var latitude: Float = 0

    let associates = ["Yava", "Fitness Club", "International Club"]

    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""

    // THEME
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData

    // MARK: - BODY

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Name of Location", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))

                    Picker("Association", selection: $associate) {
                        ForEach(associates, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    HStack {
                        Text("Price:")
                            .foregroundColor(.secondary)
                        TextField("Price", value: $price, formatter: numberFloatFormatter)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(UIColor.tertiarySystemFill))
                            .cornerRadius(9)
                            .font(.system(size: 12, weight: .bold, design: .default))
                    }

                    HStack {
                        Text("Latitude:")
                            .foregroundColor(.secondary)
                        TextField("Latitude", value: $latitude, formatter: numberFloatFormatter)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(UIColor.tertiarySystemFill))
                            .cornerRadius(9)
                            .font(.system(size: 12, weight: .bold, design: .default))
                    }

                    HStack {
                        Text("Longitude:")
                        TextField("Longitude", value: $longitude, formatter: numberFloatFormatter)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(UIColor.tertiarySystemFill))
                            .cornerRadius(9)
                            .font(.system(size: 12, weight: .bold, design: .default))
                    }

                    // MARK: - SAVE BUTTON
                    Button(action: {
                        if self.name.isEmpty {
                            self.errorShowing = true
                            self.errorTitle = "Invalid Name"
                            self.errorMessage = "Make sure to enter something for the location name."
                            return
                        }

                        Task {
                            do {
                                try await viewModel.addPoint(
                                    name: name,
                                    price: price,
                                    information: "No extra info provided", // Optional placeholder
                                    lat: Double(latitude),
                                    lon: Double(longitude),
                                    associate: associateTag(for: associate)
                                )
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                self.errorShowing = true
                                self.errorTitle = "Failed to Save"
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    }) {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[self.theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(Color.white)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 30)

                Spacer()
            }
            .navigationBarTitle("New Location", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            }
            )
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // Helper to convert association names to tags (since you are using Int tags in Firestore)
    private func associateTag(for associate: String) -> Int {
        switch associate {
        case "Yava":
            return 1
        case "Fitness Club":
            return 2
        case "International Club":
            return 3
        default:
            return 0
        }
    }
}

let numberFloatFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 5
    formatter.alwaysShowsDecimalSeparator = true
    formatter.decimalSeparator = ","
    return formatter
}()

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumListView()
            .environmentObject(AuthViewModel())
    }
}
