//
//  ErrorView.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 26/08/25.
//

import SwiftUI


struct ErrorView: View {

  let title: String
  let message: String

  init(title: String = "", message: String) {
    self.title = title
    self.message = message
  }

  var body: some View {
    VStack {
      Image(systemName: "exclamationmark.triangle.fill")
        .font(.largeTitle)
        .foregroundStyle(.gray)

      if !title.isEmpty {
        Text(title)
          .font(.title)
      }

      Text(message)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .padding()
    }
    .padding()
  }
}


#Preview {
  ErrorView(
    title: "",
    message: "No Data found!"
  )
}
