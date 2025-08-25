//
//  MovieRepository.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 25/08/25.
//

import Foundation
import BZUtil


public protocol MovieRepository: Sendable {

  func getMovies() async throws -> [any MovieEntity]
  func getMovieDetail(id: String) async throws -> (any MovieDetailEntity)
  func searchMovies(byTitle title: String) async throws -> [any MovieEntity]
}
