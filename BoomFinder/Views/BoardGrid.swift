//
//  BoardGrid.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 10/09/26.
//

import SwiftUI

struct BoardGrid: View {
  @Environment(BoardManager.self) var gameManager
  @Environment(TimerModel.self) var timerModel

  @State private var columnsValue = 10
  @State private var rowsValue = 10
  @State private var resetCount = -1
  @State private var totalBooms = 10
  @Binding var boomsLeft: Int
  @State private var board: [Int] = []
  @State private var openedItems: Set<Int> = Set()
  @State private var markedItems: Set<Int> = Set()

  private var gridLayout: [GridItem] {
    Array(
      repeating: GridItem(.fixed(Constants.tileSize), spacing: 1),
      count: columnsValue)
  }
  
  private func resetBoard() {
    resetCount += 1
    gameManager.clickCount = 0
    totalBooms = gameManager.gameMaxBooms
    boomsLeft = totalBooms
    columnsValue = gameManager.gameColumns
    rowsValue = gameManager.gameRows
    openedItems = Set()
    markedItems = Set()
    board = Array(repeating: 0, count: rowsValue * columnsValue)
    var indices = Array(0..<rowsValue * columnsValue)
    indices.shuffle()
    let boomIndices = indices.prefix(totalBooms)
    
    for idx in boomIndices {
      board[idx] = -1
    }
    
    for idx in boomIndices {
      let row = idx / columnsValue
      let col = idx % columnsValue
      
      for indexRow in -1...1 {
        for indexCol in -1...1 {
          if indexCol == 0 && indexRow == 0 { continue }
          
          let posRow = row + indexRow
          let posCol = col + indexCol
          
          if posRow >= 0 && posRow < rowsValue && posCol >= 0 && posCol < columnsValue {
            let tileIndex = posRow * columnsValue + posCol
            if board[tileIndex] != -1 {
              board[tileIndex] += 1
            }
          }
        }
      }
    }
    gameManager.gameEnded = false
  }

  private func openZeroAdjacent(item: Int) {
    var stack: Array<Int> = Array<Int>(arrayLiteral: item)
    var visited: Set<Int> = Set(arrayLiteral: item)

    while !stack.isEmpty {
      let next = stack.popLast()!
      openedItems.insert(next)

      if board[next] == 0 {
        let row = next / columnsValue
        let col = next % columnsValue

        for indexRow in -1...1 {
          for indexCol in -1...1 {
            if indexCol == 0 && indexRow == 0 { continue }

            let posRow = row + indexRow
            let posCol = col + indexCol

            if posRow >= 0 && posRow < rowsValue && posCol >= 0 && posCol < columnsValue {
              let tileIndex = posRow * columnsValue + posCol
              if !visited.contains(tileIndex){
                visited.insert(tileIndex)
                stack.append(tileIndex)
              }
            }
          }
        }
      }
    }

    resetCount += 1
  }

  private func validateWinCondition() {
    if board.count - openedItems.count == totalBooms {
      gameManager.gameWin = true
      timerModel.stop()
    }
  }

  private func handleBoomStepped() {
    gameManager.gameEnded = true
    timerModel.stop()
  }

  private func handleTileStepped(_ tileID: Int) {
    timerModel.start()
    gameManager.clickCount += 1
    if board[tileID] == 0 {
      openZeroAdjacent(item: tileID)
    } else {
      openedItems.insert(tileID)
    }
    validateWinCondition()
  }

  private func handleMarkedTile(_ item: Int) {
    timerModel.start()
    markedItems.insert(item)
    validateWinCondition()
  }

  private func handleUnMarkedTile(_ item: Int) {
    markedItems.remove(item)
    validateWinCondition()
  }

  var body: some View {
    VStack {
      ScrollView(.vertical) {
        ScrollView(.horizontal) {
          LazyVGrid(columns: gridLayout, spacing: 0) {
            ForEach(0..<board.count, id: \.self) { item in
              TileView(
                nearBooms: board[item],
                isOpen: openedItems.contains(item), isMarked: markedItems.contains(item)
              ) { boomAction in
                switch boomAction {
                case .stepped:
                  handleBoomStepped()
                case .marked:
                  handleMarkedTile(item)
                case .unmarked:
                  handleUnMarkedTile(item)
                case .tileStep:
                  handleTileStepped(item)
                }
                boomsLeft = totalBooms - markedItems.count
              }
              .id("\(resetCount)-\(item)")
            }
          }
          .padding(1)
        }
        .defaultScrollAnchor(.center, for: .alignment)
      }
    }
    .onAppear {
      resetBoard()
    }
  }
}

#Preview {
  @Previewable @State var booms = 0
  BoardGrid(boomsLeft: $booms)
    .environment(BoardManager())
    .environment(TimerModel())
}
