//
//  FitnessWidgetBundle.swift
//  FitnessWidget
//
//  Created by Petros Gedekakis on 1/5/24.
//

import WidgetKit
import SwiftUI

@main
struct FitnessWidgetBundle: WidgetBundle {
    var body: some Widget {
        FitnessWidget()
        FitnessWidgetLiveActivity()
    }
}
