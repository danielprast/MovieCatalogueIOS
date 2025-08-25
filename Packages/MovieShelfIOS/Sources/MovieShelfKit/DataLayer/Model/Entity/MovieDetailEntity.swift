//
//  MovieDetailEntity.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 25/08/25.
//

import Foundation


public protocol MovieDetailEntity: MEntity {
  var movieId: Int { get }
  var title: String { get }
  var tagline: String { get }
  var genre: [String] { get }
  var overview: String { get }
  var releaseDate: String { get }
  var status: String { get }
  var rating: Double { get }
  var revenue: Int { get }
  var runtime: Int { get }
  var posterImage: String { get }
  var backdropImage: String { get }
}


public struct MovieDetailEntityModel: MovieDetailEntity {
  public let id: String
  public let movieId: Int
  public let title: String
  public let tagline: String
  public let genre: [String]
  public let overview: String
  public let releaseDate: String
  public let status: String
  public let rating: Double
  public let revenue: Int
  public let runtime: Int
  public let posterImage: String
  public let backdropImage: String

  public init(
    id: String,
    movieId: Int,
    title: String,
    tagline: String,
    genre: [String],
    overview: String,
    releaseDate: String,
    status: String,
    rating: Double,
    revenue: Int,
    runtime: Int,
    posterImage: String,
    backdropImage: String
  ) {
    self.id = id
    self.movieId = movieId
    self.title = title
    self.tagline = tagline
    self.genre = genre
    self.overview = overview
    self.releaseDate = releaseDate
    self.status = status
    self.rating = rating
    self.revenue = revenue
    self.runtime = runtime
    self.posterImage = posterImage
    self.backdropImage = backdropImage
  }

  public static func makeEmpty() -> MovieDetailEntityModel {
    .init(
      id: "-1",
      movieId: -1,
      title: "",
      tagline: "",
      genre: [],
      overview: "",
      releaseDate: "",
      status: "",
      rating: 0,
      revenue: 0,
      runtime: 0,
      posterImage: "",
      backdropImage: ""
    )
  }

  public static func mapFromRemoteDTO(_ model: MovieDetailResponse) -> MovieDetailEntityModel {
    return MovieDetailEntityModel.init(
      id: "\(model.id)",
      movieId: model.id,
      title: model.title,
      tagline: model.tagline,
      genre: model.genres.map { $0.name },
      overview: model.overview,
      releaseDate: model.releaseDate,
      status: model.status,
      rating: model.voteAverage,
      revenue: model.revenue,
      runtime: model.runtime,
      posterImage: model.posterPath,
      backdropImage: model.backdropPath
    )
  }
}
