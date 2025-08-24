//
//  FakeMovieRemoteApiImpl.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation
import BZUtil


public struct FakeMovieRemoteApiImpl: MovieRemoteApi {

  public init() {}

  public func fetchMovies() async throws -> MovieResponse {
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

}
