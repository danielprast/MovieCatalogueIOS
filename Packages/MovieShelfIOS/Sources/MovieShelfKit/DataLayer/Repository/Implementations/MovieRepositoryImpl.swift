//
//  MovieRepositoryImpl.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 25/08/25.
//

import Foundation
import BZConnectionChecker
import BZUtil


public actor MovieRepositoryImpl: MovieRepository {
  public let movieRemoteApi: MovieRemoteApi
  public let networkConnectionChecker: NetworkConnectionChecker

  public init(
    movieRemoteApi: MovieRemoteApi,
    networkConnectionChecker: NetworkConnectionChecker
  ) {
    self.movieRemoteApi = movieRemoteApi
    self.networkConnectionChecker = networkConnectionChecker
  }

  public func getMovies() async throws -> [any MovieEntity] {
    let isConnected = await networkConnectionChecker.isConnected
    if !isConnected {
      throw MError.connectionProblem
    }

    do {
      let responseModel = try await movieRemoteApi.fetchMovies(params: [:])
      guard !responseModel.results.isEmpty else {
        return []
      }
      return responseModel.results.map { MovieEntityModel.mapFromMovieRemoteDTO($0) }
    } catch {
      throw (error as! MError)
    }
  }

  public func searchMovies(byTitle title: String) async throws -> [any MovieEntity] {
    let isConnected = await networkConnectionChecker.isConnected
    if !isConnected {
      throw MError.connectionProblem
    }

    do {
      let params: [String : String] = ["query" : title]
      let responseModel = try await movieRemoteApi.fetchMovies(params: params)
      guard !responseModel.results.isEmpty else {
        return []
      }
      return responseModel.results.map { MovieEntityModel.mapFromMovieRemoteDTO($0) }
    } catch {
      throw (error as! MError)
    }
  }

}
