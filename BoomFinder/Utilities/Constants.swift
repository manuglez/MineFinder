//
//  Constants.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 24/09/26.
//

import Foundation

struct Constants {
  static let tileSize: CGFloat = 30
}

enum BoomLevel: String, CaseIterable, Identifiable {
    case beginner, medium, expert
    var id: Self { self }
}
