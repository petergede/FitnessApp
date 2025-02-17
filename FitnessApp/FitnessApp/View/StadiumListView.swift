//
//  ListRowItemView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 24/4/24.
//

import SwiftUI

struct StadiumListView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) var managedObjectContext
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
                    // PETROS: - LOCATION NAME
                    TextField("Name of Location", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    // PETROS: - LOCATION PRIORITY
                    Picker("Association", selection: $associate) {
                        ForEach(associates, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // PETROS: - LOCATION PRICE
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
                    
                    // PETROS: - LOCATION LATITUDE
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
                    
                    // PETROS: - LOCATION LANGITUDE
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
                        if self.name != "" {
                            let location = TrainingLocation(context: self.managedObjectContext)
                            location.name = self.name
                            location.associate = self.associate
                            location.price = self.price
                            location.longitude = self.longitude
                            location.latitude = self.latitude
                            
                            do {
                                try self.managedObjectContext.save()
                                // print("New todo: \(todo.name ?? ""), Priority: \(todo.priority ?? "")")
                            } catch {
                                print(error)
                            }
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Invalid Name"
                            self.errorMessage = "Make sure to enter something for\nthe new todo item."
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[self.theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(Color.white)
                    } //: SAVE BUTTON
                } //: VSTACK
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                Spacer()
            } //: VSTACK
            .navigationBarTitle("New Todo", displayMode: .inline)
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
        } //: NAVIGATION
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Custom number formatter
  let numberFloatFormatter: NumberFormatter = {
     let formatter = NumberFormatter()
     formatter.numberStyle = .decimal
     formatter.minimumFractionDigits = 2  // Set minimum decimal places
     formatter.maximumFractionDigits = 10  // Set maximum decimal places you need
     formatter.alwaysShowsDecimalSeparator = true
     formatter.decimalSeparator = ","  // Use dot for decimals
     return formatter
 }()

// MARK: - PREIVIEW

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumListView()
            .previewDevice("iPhone 14 Pro")
    }
}
