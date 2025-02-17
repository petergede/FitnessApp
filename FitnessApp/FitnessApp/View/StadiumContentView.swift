//
//  StadiumContent.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 27/4/24.
//

import SwiftUI

struct StadiumContentView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: TrainingLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TrainingLocation.name, ascending: true)]) var locations: FetchedResults<TrainingLocation>
    
    @EnvironmentObject var iconSettings: IconNames
    
    @State private var showingSettingsView: Bool = false
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    
    // THEME
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(self.locations, id: \.self) { location in
                        NavigationLink(destination: EditLocationView(location: location)) {
                            HStack {
                                Circle()
                                    .frame(width: 12, height: 12, alignment: .center)
                                    .foregroundColor(self.colorize(associate: location.associate ?? "Unknown"))
                                Text(location.name ?? "Unknown")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text(location.associate ?? "Unknown")
                                    .font(.footnote)
                                    .foregroundColor(Color(UIColor.systemGray2))
                                    .padding(3)
                                    .frame(minWidth: 62)
                                    .overlay(
                                        Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                    )
                            } //: HSTACK
                            .padding(.vertical, 10)
                        } //: NavigationLink
                    } //: FOREACH
                    .onDelete(perform: deleteLocation)
                } //: LIST
                .navigationBarTitle("Location", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
                    trailing: Button(action: {
                        self.showingSettingsView.toggle()
                    }) {
                        Image(systemName: "paintbrush")
                            .imageScale(.large)
                    } //: SETTINGS BUTTON
                        .accentColor(themes[self.theme.themeSettings].themeColor)
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView().environmentObject(self.iconSettings)
                        }
                )
                // MARK: - NO TODO ITEMS
                if locations.count == 0 {
                    EmptyListView()
                }
            } //: ZSTACK
            .sheet(isPresented: $showingAddTodoView) {
                StadiumListView().environment(\.managedObjectContext, self.managedObjectContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.2 : 0)
                        //.scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.15 : 0)
                        //.scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    //.animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    } //: BUTTON
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                    .onAppear(perform: {
                        self.animatingButton.toggle()
                    })
                } //: ZSTACK
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
        } //: NAVIGATION
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - FUNCTIONS
    
    private func deleteLocation(at offsets: IndexSet) {
        for index in offsets {
            let location = locations[index]
            managedObjectContext.delete(location)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func colorize(associate: String) -> Color {
        switch associate {
        case "Yava":
            return .pink
        case "Fitness Club":
            return .green
        case "International Club":
            return .blue
        default:
            return .gray
        }
    }
}

