//
//  MovieDetailScreen.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 25/08/25.
//

import Foundation
import SwiftUI
import MovieShelfKit


public struct MovieDetailScreen: View {

  @Bindable var movieViewModel: MovieViewModel

  public init(movieViewModel: Bindable<MovieViewModel>) {
    self._movieViewModel = movieViewModel
  }

  public var body: some View {
    contentBody
      .navigationTitle("Movie Detail")
      .task {
        movieViewModel.getMovieDetail()
      }
  }

  public var contentBody: some View {
    Text("Movie runtime: \(movieViewModel.movieDetail?.runtime ?? 0)")
  }
}
