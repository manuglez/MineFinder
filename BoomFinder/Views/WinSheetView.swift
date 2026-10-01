//
//  WinSheetView.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 30/09/26.
//

import SwiftUI

struct WinSheetView: View {
    let seconds: Int
    let gameLevel: String
    let score: Float

    var body: some View {
      VStack {
        Text("🎉🎊 All Booms Cleared!! 😎")
        Text("Time elapsed: \(String(seconds))")
        Text("Difficulty: \(gameLevel.capitalized)")
        Text("Score: \(score)")
      }
    }
}

#Preview {
    WinSheetView(seconds: 120, gameLevel: "beginner", score: 42.0)
}
