//
//  MovieLocalDataSource.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 26/08/25.
//

import Foundation


public protocol MovieLocalDataSource: Sendable {

  func searchMovies(for title: String) async throws -> [any MovieEntity]
  func loadMovies() async throws -> [any MovieEntity]
  func save(movies: [any MovieEntity]) async throws -> Bool
}
