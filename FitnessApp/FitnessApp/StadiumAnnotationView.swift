//
//  StadiumAnnotationView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 8/4/24.
//

import SwiftUI

struct StadiumAnnotationView: View {
    var stadium: Stadium
    @Binding var selectedStadium: Stadium?
    
    var body: some View {
        Button(action: {
            self.selectedStadium = stadium
        }) {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.red)
                .background(Circle().fill(Color.white).frame(width: 30, height: 30))
        }
        .buttonStyle(PlainButtonStyle()) // Use plain style to avoid any default button styling applied by SwiftUI
    }
}

//struct StadiumAnnotationView_Previews: PreviewProvider {
//    static var previews: some View{
//        StadiumAnnotationView()
//            .environmentObject(HealthManager())
//    }
//}
