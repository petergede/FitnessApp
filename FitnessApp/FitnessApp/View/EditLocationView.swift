//
//  EditLocationView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 24/4/24.
//

import SwiftUI
import SwiftData

struct EditLocationView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var location: TrainingLocation
    
    // THEME
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    let associates = ["Yava", "Fitness Club", "International Club"]
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Name:")
                        .foregroundColor(.secondary)
                    TextField("Enter name", text: Binding(
                        get: { self.location.name ?? "" },
                        set: { self.location.name = $0 }
                    ))
                }
                
                HStack {
                    Text("Associate:")
                        .foregroundColor(.secondary)
                    Picker("Select Associate", selection: Binding(
                        get: { self.location.associate ?? associates.first ?? "" },
                        set: { self.location.associate = $0 }
                    )) {
                        ForEach(associates, id: \.self) { associate in
                            Text(associate).tag(associate)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())  // or WheelPickerStyle() based on your preference
                }
                
                HStack {
                    Text("Price:")
                        .foregroundColor(.secondary)
                    TextField("Enter price", text: Binding(
                        get: { String(format: "%.2f", self.location.price) },
                        set: { self.location.price = Double($0) ?? 0 }
                    ))
                    .keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("Latitude:")
                        .foregroundColor(.secondary)
                    TextField("Enter latitude", text: Binding(
                        get: { String(self.location.latitude) },
                        set: { self.location.latitude = Float($0) ?? 0 }
                    ))
                    .keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("Longitude:")
                        .foregroundColor(.secondary)
                    TextField("Enter longitude", text: Binding(
                        get: { String(self.location.longitude) },
                        set: { self.location.longitude = Float($0) ?? 0 }
                    ))
                    .keyboardType(.decimalPad)
                }
                
                // Update Button
                Button(action: {
                    if self.location.name != "" {
                        // If the location is not already in the managed object context, add it.
                        if self.location.managedObjectContext == nil {
                            self.managedObjectContext.insert(self.location)
                        }
                        
                        // Attempt to save changes or new entry
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print("Failed to save managed object context: \(error)")
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        // Handle the error for empty name
                        print("Invalid name. Please enter a name for the location.")
                    }
                }) {
                    Text("Update")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(themes[self.theme.themeSettings].themeColor)
                        .cornerRadius(9)
                        .foregroundColor(Color.white)
                }
            }
            .navigationBarTitle("Edit Location", displayMode: .inline)
        }
    }
}
