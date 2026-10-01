//
//  TimerView.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 24/09/26.
//

import SwiftUI
import Combine

struct TimerView: View {
  @Environment(BoardManager.self) var gameManager
  /*@State var isRunning: Bool
  @State private var seconds = 0

  @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
  @State private var cancellable: Cancellable?
*/
  let timerModel: TimerModel

  var body: some View {
    VStack {
      Label("\(timerModel.seconds)", systemImage: "timer")
        .font(.system(size: 24, weight: .medium, design: .monospaced))
        .backgroundStyle(.cyan)

    }

    .backgroundStyle(.cyan)
    /*.onReceive(timer) { _ in
      print("timer \(isRunning)")
      guard isRunning else { return }
      seconds += 1
    }
    .onAppear {
      print("TimerView Appear")
      if isRunning {
        seconds = 0
        cancellable = timer.connect()
      } else {
        cancellable?.cancel()
        cancellable = nil
      }
    }
    .onDisappear(){
      print("TimerView Disappear")
    }*/
  }
}

#Preview(traits: .sizeThatFitsLayout) {

  TimerView(timerModel: TimerModel())
    .padding()
    .environment(BoardManager())
}
