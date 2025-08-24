//
//  ApiEndpoints.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

public enum ApiEndpoints: String, Sendable {
  case discoverMovies = "/3/discover/movie"

  public var path: String { self.rawValue }
}
