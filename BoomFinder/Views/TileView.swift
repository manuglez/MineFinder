//
//  TileView.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 07/09/26.
//

import SwiftUI

struct TileView: View {
  enum BoomState {
    case initial, open, boom, marked, exploded, empty
  }

  enum BoomAction {
    case stepped, marked, unmarked, tileStep
  }

  let nearBooms: Int
  let isOpen: Bool
  let isMarked: Bool

  let boomAction: (BoomAction) -> Void

  let emojiSymbols = ["💣", "💥", "🚩"]

  @Environment(BoardManager.self) var gameManager
  
  @State private var state: BoomState = .initial

  private var isBoom: Bool { nearBooms < 0 }

  private func getTileBgColor() -> UIColor {
    if gameManager.gameEnded {
      if state == .marked && isBoom {
        return .systemGreen
      } else if state == .marked && !isBoom {
        return .systemRed
      }
    }

    if state == .empty {
      return .systemGray
    }
    return .systemGray5
  }

  private func color(for value: Int) -> Color {
      switch value {
      case 1: return .blue
      case 2: return .green
      case 3: return .red
      case 4: return .indigo
      case 5: return .brown
      case 6: return .cyan
      case 7: return .purple
      case 8: return .gray
      default: return .primary
      }
  }

    var body: some View {
      Button(action: {
        if !gameManager.gameEnded {
          if isBoom {
            state = .exploded
            boomAction(.stepped)
          } else {
            if state == .marked {
              boomAction(.unmarked)
            }
            if nearBooms == 0 {
              state = .empty
            } else {
              state = .open
            }
            boomAction(.tileStep)
          }
        }
      }) {
        ZStack {
          switch state {
          case .initial:
            Text(gameManager.gameEnded && isBoom ? emojiSymbols[0] : " ")
            //Text("\(nearBooms)")
          case .open:
            Text("\(nearBooms)")
              .font(.title2)
              .fontWeight(.heavy)
              .foregroundStyle(color(for: nearBooms))
          case .boom:
            Text(emojiSymbols[0])
          case .exploded:
            Text(emojiSymbols[1])
          case .marked:
            Text(emojiSymbols[2])
          case .empty:
            Text(" ")
          }
        }
      }
      .buttonStyle(.plain)
      .frame(width: Constants.tileSize, height: Constants.tileSize)
      .background(Color(uiColor: getTileBgColor()))
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .background(
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color.gray, lineWidth: 1)
      )
      .shadow(color: .black.opacity(0.4), radius: 1)
      .highPriorityGesture(
        LongPressGesture(minimumDuration: 0.5)
          .onEnded { _ in
            switch state {
            case .initial:
              state = .marked
              boomAction(.marked)
            case .marked:
              state = .initial
              boomAction(.unmarked)
            default:
              break
            }

          }
      )
      .onAppear {
        if isMarked {
          state = .marked
        } else if isOpen {
          if nearBooms == 0 {
            state = .empty
          } else {
            state = .open
          }
        } else {
          state = .initial
        }
      }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
  TileView(
    nearBooms: 1,
    isOpen: true,
    isMarked: false,
    boomAction: {_ in }
  )
    .environment(BoardManager())
}
