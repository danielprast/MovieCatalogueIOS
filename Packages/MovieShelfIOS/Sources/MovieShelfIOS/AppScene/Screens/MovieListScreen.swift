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
            MovieListView(movies: movieViewModel.filteredMovies) { didTapItem(movie: $0) }
          } else {
            MovieListView(movies: movieViewModel.movies) { didTapItem(movie: $0) }
          }
        }
      }
    }
  }

  fileprivate func didTapItem(movie: any MovieEntity) {
    movieViewModel.selectedMovie = movie
    movieViewModel.presentDetail()
  }
}


struct MovieListView: View {

  let movies: [any MovieEntity]
  let onTapItem: (any MovieEntity) -> Void

  var body: some View {
    if movies.isEmpty {
      ErrorView(message: "No Data")
    } else {
      List(movies, id: \.id) { movie in
        itemView(model: movie)
          .onTapGesture {
            onTapItem(movie)
          }
      }
    }
  }

  @ViewBuilder
  fileprivate func itemView(model: any MovieEntity) -> some View {
    HStack(spacing: 12) {
      AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterImage)")!) { image in
        image
          .resizable()
          .scaledToFit()
          .frame(width: 150 * 0.667, height: 150)
          .clipShape(RoundedRectangle(cornerRadius: 8))
      } placeholder: {
        ZStack {
          ProgressView()
        }
        .frame(width: 150 * 0.667, height: 150)
      }
      .clipped()
      .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))

//      ZStack {
//        ProgressView()
//      }
//      .frame(width: 150 * 0.667, height: 150)
//      .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))

      VStack(alignment: .leading, spacing: 8) {
        Text(model.title)
          .font(.headline)
          .fontWeight(.bold)

        Text(model.releaseDate)
          .font(.subheadline)
          .foregroundStyle(Color.gray)

        Spacer()
      }
      .padding(.top, 12)

      Spacer()
    }
    .frame(
      maxWidth: .infinity,
      maxHeight: 150,
      alignment: .leading
    )
    .background(Rectangle().fill(Color.white))
    .listRowSeparator(.hidden)
  }
}


#Preview {
  MovieListView(
    movies: MovieEntityModel.samples,
    onTapItem: { _ in
    }
  )
}
