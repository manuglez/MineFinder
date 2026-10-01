//
//  BoardManager.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 09/09/26.
//

import SwiftUI
import Observation

@Observable
class BoardManager {
  var gameEnded: Bool = false
  var gameWin: Bool = false
  //var gameRunning: Bool = false
  var gameColumns: Int = 10
  var gameRows: Int = 10
  var gameMaxBooms: Int = 12
  var clickCount: Int = 0
  var gameLevel: BoomLevel = .beginner

  func reset() {
    gameEnded = false
    gameWin = false
  }

}
