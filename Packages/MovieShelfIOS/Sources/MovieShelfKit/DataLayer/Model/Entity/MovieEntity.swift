//
//  MovieEntity.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 25/08/25.
//

import Foundation


public protocol MovieEntity: MEntity {
  var movieId: Int { get }
  var title: String { get }
  var posterImage: String { get }
  var releaseDate: String { get }
  var rating: Double { get }
  var detail: any MovieDetailEntity { get }
}


extension MovieEntity {

  public static func mapFromMovieRemoteDTO(_ model: MovieResponse.Result) -> any MovieEntity {
    return MovieEntityModel(
      id: "\(model.id)",
      movieId: model.id,
      title: model.title,
      posterImage: model.posterPath,
      backdropImage: model.backdropPath,
      releaseDate: model.releaseDate,
      rating: model.voteAverage,
      detail: MovieDetailEntityModel.makeEmpty()
    )
  }
}


public struct MovieEntityModel: MovieEntity {
  public let id: String
  public let movieId: Int
  public let title: String
  public let posterImage: String
  public let backdropImage: String
  public let releaseDate: String
  public let rating: Double
  public let detail: any MovieDetailEntity

  public init(
    id: String,
    movieId: Int,
    title: String,
    posterImage: String,
    backdropImage: String,
    releaseDate: String,
    rating: Double,
    detail: any MovieDetailEntity
  ) {
    self.id = id
    self.movieId = movieId
    self.title = title
    self.posterImage = posterImage
    self.backdropImage = backdropImage
    self.releaseDate = releaseDate
    self.rating = rating
    self.detail = detail
  }

  public func copyWith(
    id: String? = nil,
    movieId: Int? = nil,
    title: String? = nil,
    posterImage: String? = nil,
    backdropImage: String? = nil,
    releaseDate: String? = nil,
    rating: Double? = nil,
    detail: MovieDetailEntityModel? = nil
  ) -> MovieEntityModel {
    .init(
      id: id ?? self.id,
      movieId: movieId ?? self.movieId,
      title: title ?? self.title,
      posterImage: posterImage ?? self.posterImage,
      backdropImage: backdropImage ?? self.backdropImage,
      releaseDate: releaseDate ?? self.releaseDate,
      rating: rating ?? self.rating,
      detail: detail ?? self.detail
    )
  }

  public static func makeEmpty() -> MovieEntityModel {
    .init(
      id: UUID().uuidString,
      movieId: -1,
      title: "",
      posterImage: "",
      backdropImage: "",
      releaseDate: "",
      rating: 0,
      detail: MovieDetailEntityModel.makeEmpty()
    )
  }

}
