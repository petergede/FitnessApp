//
//  AppIntent.swift
//  MonthlyWidget
//
//  Created by Petros Gedekakis on 9/4/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Upcoming event", default: "Patras Marathon")
    var eventDescription: String
}
