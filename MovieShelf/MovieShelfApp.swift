//
//  MovieShelfApp.swift
//  MovieShelf
//
//  Created by Daniel Prastiwa on 23/08/25.
//

import SwiftUI
import MovieShelfIOS


@main
struct MovieShelfApp: App {

  let dependencyFactory = MainDependencyFactory()

  var body: some Scene {
    WindowGroup {
      MovieScope(mainDependencyFactory: self.dependencyFactory)
    }
  }
}
