//
//  ApiEndpoints.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

public enum ApiEndpoints: Sendable {
  case discoverMovies
  case movieSearch
  case movieDetail(id: String)

  public var path: String {
    switch self {
    case .discoverMovies:
      "/3/discover/movie"
    case .movieDetail(let id):
      "/3/movie/\(id)"
    case .movieSearch:
      "/3/search/movie"
    }
  }
}
