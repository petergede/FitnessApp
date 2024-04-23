//
//  MonthlyWidgetBundle.swift
//  MonthlyWidget
//
//  Created by Petros Gedekakis on 9/4/24.
//

import WidgetKit
import SwiftUI

@main
struct MonthlyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MonthlyWidget()
        MonthlyWidgetLiveActivity()
    }
}
