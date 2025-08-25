//
//  FakeMovieRemoteApiImpl.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation
import BZUtil


public struct FakeMovieRemoteApiImpl {

  public init() {}

  // MARK: • Movie RemoteApi

  public func fetchMovies(params: [String : any Sendable]) async throws -> MovieResponse {
    guard
      let jsonData = JsonResolver.readJsonFileFromResource(
        bundle: Foundation.Bundle.module,
        fileName: "movie_list"
      ),
      let dataModel = JsonResolver.decodeJson(from: jsonData, outputType: MovieResponse.self)
    else {
      throw MError.parsingError
    }
    return dataModel
  }

  // MARK: • Movie Detail RemoteApi

  public func fetchDetailMovie(id: String) async throws -> MovieDetailResponse {
    guard
      let jsonData = JsonResolver.readJsonFileFromResource(
        bundle: Foundation.Bundle.module,
        fileName: "movie_detail"
      ),
      let dataModel = JsonResolver.decodeJson(
        from: jsonData,
        outputType: MovieDetailResponse.self
      )
    else {
      throw MError.parsingError
    }
    return dataModel
  }

}


extension FakeMovieRemoteApiImpl: MovieRemoteApi, MovieDetailRemoteApi {}
