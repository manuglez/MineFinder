//
//  TimerModel.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 29/09/26.
//

import Foundation
import SwiftUI
import Combine
import Observation

@MainActor
@Observable
final class TimerModel {
    private(set) var seconds = 0
    private(set) var isRunning = false

    @ObservationIgnored
    private var cancellable: AnyCancellable?

    func start() {
        guard !isRunning else { return }
      print("Start Timer")
        isRunning = true
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
              print("sink")
                self?.seconds += 1
            }
    }

    func stop() {
        cancellable?.cancel()
        cancellable = nil
        isRunning = false
    }

    func reset() {
        stop()
        seconds = 0
    }
}
