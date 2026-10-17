//
//  SearchIntent.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/17/26.
//

import Foundation

enum SearchIntent {
    case queryChanged(String)   // the user typed; the new text travels with it
    case searchSubmitted        // the user pressed Return
    case refreshPulled          // the user pulled the list down
}
