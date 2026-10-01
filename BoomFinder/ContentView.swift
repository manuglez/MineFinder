//
//  ContentView.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 07/09/26.
//

import SwiftUI

struct ContentView: View {
  @State private var boomsLeft = 0
  @State private var count = 0

  @State var gameManager = BoardManager()
  @State private var timerModel = TimerModel()

  private var score: Float {
    guard timerModel.seconds > 0 else { return 0.0 }
    print("score: \(gameManager.clickCount) / \(timerModel.seconds) = \(Float(gameManager.clickCount / timerModel.seconds) * 100 )")
    return Float(gameManager.clickCount) / Float(timerModel.seconds) * 100
  }

  func reset() {
    boomsLeft = 0
    count += 1
    gameManager.reset()
    timerModel.reset()
  }

  var body: some View {
    NavigationStack {
      VStack(alignment: .center, spacing: 10) {
        HStack() {
          Label("Booms: \(boomsLeft)", systemImage: "burst.fill")

          Spacer()

          TimerView(timerModel: timerModel)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)

        HStack(alignment: .top) {
          Spacer()
          BoardGrid(boomsLeft: $boomsLeft)
            .id(count)
          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        Button(action: {
          reset()
        }) {
          Text("RESET")
            .font(.system(size: 24, weight: .medium))
            .foregroundStyle(Color(uiColor: .lightText))
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity)
        .background {
          Capsule(style: .continuous)
            .fill(.link)

        }
      }
      .padding(.horizontal, 10)
      .backgroundStyle(.yellow)
      .navigationTitle("BoomFinder")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink {
            SettingsView()
              .environment(gameManager)
          } label: {
            Image(systemName: "slider.horizontal.3")
          }
        }
      }
      .sheet(isPresented: $gameManager.gameWin) {
        WinSheetView(
            seconds: timerModel.seconds,
            gameLevel: String(describing: gameManager.gameLevel),
            score: self.score
        )
        .padding()
        .presentationDetents([.fraction(0.5)])
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(24)
      }
      .sheet(isPresented: $gameManager.gameEnded) {
        LoseSheetView(
          seconds: timerModel.seconds,
          gameLevel: String(describing: gameManager.gameLevel)
        )
        .padding()
        .presentationDetents([.fraction(0.5)])
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(24)
      }

      .environment(gameManager)
      .environment(timerModel)

    }
    .onDisappear {
      timerModel.stop()
    }
  }



}

#Preview {
    ContentView()
}

