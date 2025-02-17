//
//  FavoritesView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 1/5/24.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel = EventManager()

    var body: some View {
        List(viewModel.events.filter { $0.isFavorite ?? false }) { event in
            HStack {
                Base64ImageView(base64String: event.titleImage.base64)
                    .frame(width: 100, height: 100)
                VStack(alignment: .leading) {
                    Text(event.name)
                        .font(.headline)
                    Text(event.date)
                        .font(.subheadline)
                }
                Spacer()
                Button(action: {
                    viewModel.toggleFavorite(for: event)
                }) {
                    Image(systemName: event.isFavorite ?? false ? "heart.fill" : "heart")
                        .foregroundColor(event.isFavorite ?? false ? .red : .gray)
                }
            }
        }
    }
}

#Preview {
    FavoritesView()
}

