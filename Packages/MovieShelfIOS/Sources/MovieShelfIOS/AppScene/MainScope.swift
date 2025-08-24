//
//  MainScope.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 23/08/25.
//

import SwiftUI
import MovieShelfKit


public struct MainScope: View {

  public init() {}

  public var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Main Scope")
      Text("Api Key: \(AppEnv.apikey())")
      Text("Base URL: \(AppEnv.baseUrl())")
      Text("Image Base URL: \(AppEnv.imageBaseUrl())")
    }
  }
}
