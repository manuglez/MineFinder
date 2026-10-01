//
//  SettingsView.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 22/09/26.
//

import SwiftUI

struct SettingsView: View {
  @Environment(BoardManager.self) var gameManager
  
  @State private var columns = 10
  @State private var rows = 10
  @State private var maxBooms = 10
  @State private var boomsLevel: BoomLevel = .beginner

  var maxLimitBoom: Int { (columns * rows) - 1 }

  private func updateBoomsLevel() {
    maxBooms = Int((Float)(columns * rows) * boomDensity)
    gameManager.gameMaxBooms = maxBooms
    gameManager.gameLevel = boomsLevel
  }

  private var boomDensity: Float {
    switch boomsLevel {
    case .beginner:
      return 0.123
    case .medium:
      return 0.156
    case .expert:
      return 0.206
    }
  }

  var body: some View {
    ScrollView(.vertical) {
      VStack {
        SettingsStepperView(
          label: "Columns",
          value: $columns,
          onChange: {
            gameManager.gameColumns = columns
            updateBoomsLevel()
          }
        )
        Divider()
        SettingsStepperView(
          label: "Rows",
          value: $rows,
          onChange: {
            gameManager.gameRows = rows
            updateBoomsLevel()
          }
        )
        Divider()
        /*SettingsStepperView(
          label: "Max Booms",
          value: $maxBooms,
          range: 1...maxLimitBoom,
          onChange: {
            gameManager.gameMaxBooms = maxBooms
          }
        )
        Divider()*/

        HStack {
          Text("Level (\(maxBooms) booms)")
          Spacer()
          Picker("Bombs", selection: $boomsLevel) {
            ForEach(BoomLevel.allCases) { level in
              Text(level.rawValue.capitalized)
            }
          }
          .pickerStyle(.menu)
          .onChange(of: boomsLevel) {
            print("Picker change (\(boomsLevel.rawValue))")
            updateBoomsLevel()
          }
        }
        .padding(.horizontal, 10)
        Divider()
      }
      .padding()
    }
    .navigationTitle("Settings")
    .onAppear {
      columns = gameManager.gameColumns
      rows = gameManager.gameRows
      boomsLevel = gameManager.gameLevel
      print("Picker value (\(boomsLevel.rawValue))")
      updateBoomsLevel()
    }
}
  }


#Preview {
    SettingsView()
    .environment(BoardManager())
}
