//
//  SettingsStepperView.swift
//  BoomFinder
//
//  Created by Manuel Gonzalez Lara on 22/09/26.
//

import SwiftUI

struct SettingsStepperView: View {

  var label: String
  @Binding var value: Int

  var range = 2...30

  var onChange: () -> ()?
  var body: some View {
    HStack {
      Spacer()
      Stepper(
        "\(label)",
        value: $value,
        in: range,
      )
      .onChange(of: value) {
        onChange()
      }
      Text("\(value)")
      Spacer()
    }
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  @Previewable @State var val = 10
  SettingsStepperView(label: "Label" , value: $val, onChange: {})
    .padding()
}
