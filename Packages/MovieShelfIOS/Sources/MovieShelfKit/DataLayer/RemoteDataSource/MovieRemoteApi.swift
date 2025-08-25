//
//  MovieRemoteApi.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation


public protocol MovieRemoteApi: Sendable {

  func fetchMovies(params: [String : any Sendable]) async throws -> MovieResponse
}


public protocol MovieSearchRemoteApi: Sendable {

  func fetchSearchMovies(params: [String : any Sendable]) async throws -> MovieResponse
}


public protocol MovieDetailRemoteApi: Sendable {

  func fetchDetailMovie(id: String) async throws -> MovieDetailResponse
}
