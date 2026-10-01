//
//  LoseSheetView.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 30/09/26.
//

import SwiftUI

struct LoseSheetView: View {
  let seconds: Int
  let gameLevel: String
  
  var body: some View {
    VStack {
      Text("Stepped on a Boom. Try Again ☠️")
      Text("Time elapsed: \(String(seconds))")
      Text("Difficulty: \(gameLevel.capitalized)")
    }
  }
}

#Preview {
    LoseSheetView(seconds: 120, gameLevel: "beginner")
}
