//
//  MovieViewModel.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation
import Combine
import BZUtil


@Observable @MainActor
public final class MovieViewModel {

  public let movieRepository: MovieRepository

  public init(movieRepository: MovieRepository) {
    self.movieRepository = movieRepository
    handleSearchQueryBehavior()
    Task { getMovies() }
  }

  deinit {
    clog("💥 \(Self.self)", "destroyed")
    disposeAnyCancellables()
  }

  func handleSearchQueryBehavior() {
    debouncedSearchQuery
      .debounce(
        for: .milliseconds(700),
        scheduler: RunLoop.main
      )
      .removeDuplicates()
      .sink { [weak self] value in
        guard let self else { return }
        update(movieSearchMode: !searchQuery.isEmpty)
        if searchQuery.isEmpty {
          filteredMovies.removeAll()
        }
        searchMovies()
      }
      .store(in: &cancellables)
  }

  @ObservationIgnored private var cancellables = Set<AnyCancellable>()
  @ObservationIgnored private var debouncedSearchQuery = PassthroughSubject<String, Never>()

  public var getMoviesError: MError?
  public var getMoviesLoading: Bool = false
  public var movies: [any MovieEntity] = []
  public var selectedMovie: (any MovieEntity)?
  public var movieSearchMode: Bool = false
  public var filteredMovies: [any MovieEntity] = []
  public var searchQuery: String = "" {
    didSet {
      debouncedSearchQuery.send(searchQuery)
    }
  }

  public var getMovieDetailError: MError?
  public var getMovieDetailLoading: Bool = false
  public var movieDetail: (any MovieDetailEntity)?

  public func update(movieSearchMode: Bool) {
    self.movieSearchMode = movieSearchMode
  }

  nonisolated private func disposeAnyCancellables() {
    Task { await removeCancellables() }
  }

  private func removeCancellables() {
    cancellables.removeAll()
  }

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

  public func searchMovies() {
    Task { [movieRepository] in
      getMoviesError = nil
      getMoviesLoading = true

      do {
        let movies = try await movieRepository.searchMovies(byTitle: searchQuery)
        self.filteredMovies = movies
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
        movieDetail = MovieDetailEntityModel(
          id: selectedMovie?.id ?? "",
          movieId: selectedMovie?.movieId ?? -1,
          title: selectedMovie?.title ?? "",
          tagline: "",
          genre: [],
          overview: selectedMovie?.description ?? "",
          releaseDate: selectedMovie?.releaseDate ?? "",
          status: "",
          rating: 0,
          revenue: -1,
          runtime: -1,
          posterImage: selectedMovie?.posterImage ?? "",
          backdropImage: ""
        )
      }
    }
  }

  // MARK: - • Navigation

  public var routePaths: [MovieRoute] = []

  public func presentDetail() {
    routePaths.append(MovieRoute.MovieDetail)
    llog("route paths", routePaths)
  }

}


extension MovieViewModel {

  public func llog(
    _ key: String,
    _ value: Any,
    type: TLogType = .info,
    subsystem: String = "module",
    file: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    clog(
      "\(Self.self) ≈ \(key)",
      value,
      type: type,
      subsystem: subsystem,
      file: file,
      function: function,
      line: line
    )
  }

}
