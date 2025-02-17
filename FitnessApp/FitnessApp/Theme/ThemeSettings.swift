//
//  ThemeSettings.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 27/4/24.
//

import Foundation
import SwiftUI

// THEME CLASS

final public class ThemeSettings: ObservableObject {
  @Published public var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
    didSet {
      UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
    }
  }
  
  private init() {}
  public static let shared = ThemeSettings()
}
