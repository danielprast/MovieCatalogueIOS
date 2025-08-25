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
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity
      )
      .navigationTitle("Top Rated Movies")
      .searchable(
        text: $movieViewModel.searchQuery,
        prompt: "Movie title..."
      )
      .task {
        movieViewModel.getMovies()
      }
  }

  public var contentBody: some View {
    ZStack {
      if movieViewModel.getMoviesLoading {
        ProgressView()
      } else {
        if let error = movieViewModel.getMoviesError {
          ErrorView(message: error.errorMessage)
        } else {
          if movieViewModel.movieSearchMode {
            ListView(movies: movieViewModel.filteredMovies)
          } else {
            ListView(movies: movieViewModel.movies)
          }
        }
      }
    }
  }

  @ViewBuilder
  fileprivate func ListView(movies: [any MovieEntity]) -> some View {
    if movies.isEmpty {
      ErrorView(message: "No Data")
    } else {
      List(movies, id: \.id) { movie in
        Text(movie.title)
          .frame(
            maxWidth: .infinity,
            alignment: .leading
          )
          .background(Rectangle().fill(Color.white))
          .listRowSeparator(.hidden)
          .onTapGesture {
            movieViewModel.selectedMovie = movie
            movieViewModel.presentDetail()
          }
      }
    }
  }
}
