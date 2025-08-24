//
//  MovieRemoteApi.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation


public protocol MovieRemoteApi: Sendable {

  func fetchMovies() async throws -> MovieResponse
}
