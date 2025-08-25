//
//  MovieListScreen.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 25/08/25.
//

import Foundation
import SwiftUI
import MovieShelfKit


public struct MovieListScreen: View {

  @Bindable private var movieViewModel: MovieViewModel

  public init(movieViewModel: Bindable<MovieViewModel>) {
    self._movieViewModel = movieViewModel
  }

  public var body: some View {
    contentBody
      .navigationTitle("Movies")
      .task {
        movieViewModel.getMovies()
      }
  }

  public var contentBody: some View {
    List(movieViewModel.movies, id: \.id) { movie in
      Text(movie.title)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Rectangle().fill(Color.white))
        .listRowSeparator(.hidden)
        .onTapGesture {
          movieViewModel.selectedMovie = movie
          movieViewModel.presentDetail()
        }
    }
  }
}
