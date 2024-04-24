//
//  Base64ImageView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 9/4/24.
//

import SwiftUI

struct Base64ImageView: View {
    let base64String: String

    var body: some View {
        // Decode the base64 string to an image
        guard let imageData = decodeBase64ToData(base64String),
              let uiImage = UIImage(data: imageData) else {
            // Fallback to a placeholder image
            return AnyView(placeholderImage)
        }
        
        // Display the decoded image
        return AnyView(
            Image(uiImage: uiImage)
                .resizable() // Make the image resizable
                .scaledToFit() // Scale the image to fit its container
                // Optionally, remove the frame to allow the image to use its natural size
                // or adjust the frame as necessary to fit your UI design
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }

    private func decodeBase64ToData(_ base64String: String) -> Data? {
        guard base64String.contains("base64,") else {
            return nil
        }
        let parts = base64String.split(separator: ",", maxSplits: 1).map(String.init)
        guard parts.count == 2, let imageData = Data(base64Encoded: parts[1], options: .ignoreUnknownCharacters) else {
            return nil
        }
        return imageData
    }

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


