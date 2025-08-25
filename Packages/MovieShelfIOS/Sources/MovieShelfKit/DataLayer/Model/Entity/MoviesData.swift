//
//  MoviesData.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 25/08/25.
//

import Foundation


public protocol MoviesDataEntity: MEntity {
  var page: Int { get }
  var movies: [any MovieEntity] { get }
  var totalPages: Int { get }
  var totalResults: Int { get }
}


public struct MoviesDataEntityModel: MoviesDataEntity {
  public let id: String
  public let page: Int
  public let movies: [any MovieEntity]
  public let totalPages: Int
  public let totalResults: Int

  public init(
    id: String,
    page: Int,
    movies: [any MovieEntity],
    totalPages: Int,
    totalResults: Int
  ) {
    self.id = id
    self.page = page
    self.movies = movies
    self.totalPages = totalPages
    self.totalResults = totalResults
  }

  public func copyWith(
    id: String? = nil,
    page: Int? = nil,
    movies: [any MovieEntity]? = nil,
    totalPages: Int? = nil,
    totalResults: Int? = nil
  ) -> MoviesDataEntityModel {
    return .init(
      id: id ?? self.id,
      page: page ?? self.page,
      movies: movies ?? self.movies,
      totalPages: totalPages ?? self.totalPages,
      totalResults: totalResults ?? self.totalResults
    )
  }
}
