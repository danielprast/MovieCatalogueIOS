//
//  MovieViewModel.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation
import BZUtil


@Observable @MainActor
public final class MovieViewModel {

  public let movieRepository: MovieRepository

  public init(movieRepository: MovieRepository) {
    self.movieRepository = movieRepository
  }

  deinit {
    clog("💥 \(Self.self)", "destroyed")
  }

  public var getMoviesError: MError?
  public var getMoviesLoading: Bool = false
  public var movies: [any MovieEntity] = []
  public var selectedMovie: (any MovieEntity)?

  public var getMovieDetailError: MError?
  public var getMovieDetailLoading: Bool = false
  public var movieDetail: (any MovieDetailEntity)?

  // MARK: - • Usecase

  public func getMovies() {
    if getMoviesLoading {
      return
    }

    Task(priority: .userInitiated) { [movieRepository] in
      do {
        getMoviesError = nil
        getMoviesLoading = true
        let movies = try await movieRepository.getMovies()
        self.movies = movies
        getMoviesLoading = false
      } catch {
        getMoviesError = (error as! MError)
        getMoviesLoading = false
      }
    }
  }

  public func getMovieDetail() {
    if getMovieDetailLoading {
      return
    }

    Task(priority: .userInitiated) { [movieRepository] in
      getMovieDetailError = nil
      getMovieDetailLoading = true
      do {
        let id = selectedMovie!.id
        let movieDetail = try await movieRepository.getMovieDetail(id: id)
        self.movieDetail = movieDetail
        getMovieDetailLoading = false
      } catch {
        getMovieDetailError = (error as! MError)
        getMovieDetailLoading = false
      }
    }
  }

  // MARK: - • Navigation

  public var routePaths: [MovieRoute] = []

  public func presentDetail() {
    routePaths.append(MovieRoute.MovieDetail)
    clog("route paths", routePaths)
  }

}
