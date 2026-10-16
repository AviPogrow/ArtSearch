//
//  ArtworkRow.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
//

import Foundation
import SwiftUI

struct ArtworkRow: View {
    let artwork: Artwork

    var body: some View {
        VStack(alignment: .leading) {
            Text(artwork.title)
                .font(.headline)
            Text(artwork.artist)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
