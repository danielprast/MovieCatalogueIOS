//
//  OfflineFirstMovieRepository.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 26/08/25.
//

import Foundation
import BZConnectionChecker
import BZUtil


public actor OfflineFirstMovieRepositoryImpl: MovieRepository {

  public let movieLocalDataSource: MovieLocalDataSource
  public let movieRemoteApi: MovieRemoteApi
  public let movieSearchRemoteApi: MovieSearchRemoteApi
  public let movieDetailRemoteApi: MovieDetailRemoteApi
  public let networkConnectionChecker: NetworkConnectionChecker

  public init(
    movieLocalDataSource: MovieLocalDataSource,
    movieRemoteApi: MovieRemoteApi,
    movieDetailRemoteApi: MovieDetailRemoteApi,
    movieSearchRemoteApi: MovieSearchRemoteApi,
    networkConnectionChecker: NetworkConnectionChecker
  ) {
    self.movieLocalDataSource = movieLocalDataSource
    self.movieRemoteApi = movieRemoteApi
    self.movieDetailRemoteApi = movieDetailRemoteApi
    self.movieSearchRemoteApi = movieSearchRemoteApi
    self.networkConnectionChecker = networkConnectionChecker
  }

  public func getMovies() async throws -> [any MovieEntity] {
    let isConnected = await networkConnectionChecker.isConnected
    if !isConnected {
      return try await movieLocalDataSource.loadMovies()
    }

    do {
      let responseModel = try await movieRemoteApi.fetchMovies(params: [:])
      guard !responseModel.results.isEmpty else {
        return []
      }
      let entities = responseModel.results.map { MovieEntityModel.mapFromMovieRemoteDTO($0) }
      let _ = try await movieLocalDataSource.save(movies: entities)
      return entities
    } catch {
      throw (error as! MError)
    }
  }

  public func searchMovies(byTitle title: String) async throws -> [any MovieEntity] {
    let isConnected = await networkConnectionChecker.isConnected
    if !isConnected {
      return try await movieLocalDataSource.searchMovies(for: title)
    }

    do {
      let params: [String : String] = ["query" : title]
      llog("searching movies...", params)
      let responseModel = try await movieSearchRemoteApi.fetchSearchMovies(params: params)
      llog("search result", responseModel.results.count)
      guard !responseModel.results.isEmpty else {
        return []
      }
      return responseModel.results.map { MovieEntityModel.mapFromMovieRemoteDTO($0) }
    } catch {
      throw (error as! MError)
    }
  }

  public func getMovieDetail(id: String) async throws -> (any MovieDetailEntity) {
    let isConnected = await networkConnectionChecker.isConnected
    if !isConnected {
      throw MError.connectionProblem
    }

    do {
      let responseModel = try await movieDetailRemoteApi.fetchDetailMovie(id: id)
      let entity = MovieDetailEntityModel.mapFromRemoteDTO(responseModel)
      return entity
    } catch {
      throw (error as! MError)
    }
  }

}


extension OfflineFirstMovieRepositoryImpl {

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
