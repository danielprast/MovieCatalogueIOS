//
//  MovieScope.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 23/08/25.
//

import SwiftUI
import MovieShelfKit


public struct MovieScope: View {

  let mainDependencyFactory: MainDependencyFactory
  @Bindable private var movieViewModel: MovieViewModel

  public init(mainDependencyFactory: MainDependencyFactory) {
    self.mainDependencyFactory = mainDependencyFactory
    _movieViewModel = Bindable(wrappedValue: mainDependencyFactory.makeMovieViewModel())
  }

  public var body: some View {
    NavigationStack(
      path: $movieViewModel.routePaths
    ) {
      MovieListScreen(movieViewModel: $movieViewModel)
        .navigationDestination(for: MovieRoute.self) { route in
          switch route {
          case .MovieList:
            EmptyView()
          case .MovieDetail:
            MovieDetailScreen(movieViewModel: $movieViewModel)
          }
        }
    }
  }
}
