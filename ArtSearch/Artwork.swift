//
//  Artwork.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
//
import Foundation

struct Artwork: Identifiable, Decodable {
    let id: Int
    let title: String
    let artist: String

    enum CodingKeys: String, CodingKey {
        case id = "objectID"
        case title
        case artist = "artistDisplayName"
    }
}
