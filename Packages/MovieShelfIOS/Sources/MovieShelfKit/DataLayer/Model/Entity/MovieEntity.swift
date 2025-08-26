//
//  MovieEntity.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 25/08/25.
//

import Foundation
import BZUtil


public protocol MovieEntity: MEntity {
  var id: String { get }
  var movieId: Int { get }
  var title: String { get }
  var description: String { get }
  var posterImage: String { get }
  var releaseDate: String { get }
  var rating: Double { get }
  var detail: any MovieDetailEntity { get }
  var metadata: String { get }
}


public struct MovieEntityModel: MovieEntity {
  public let id: String
  public let movieId: Int
  public let title: String
  public let description: String
  public let posterImage: String
  public let backdropImage: String
  public let releaseDate: String
  public let rating: Double
  public let detail: any MovieDetailEntity
  public let metadata: String

  public init(
    id: String,
    movieId: Int,
    title: String,
    description: String,
    posterImage: String,
    backdropImage: String,
    releaseDate: String,
    metadata: String,
    rating: Double,
    detail: any MovieDetailEntity
  ) {
    self.id = id
    self.movieId = movieId
    self.title = title
    self.description = description
    self.posterImage = posterImage
    self.backdropImage = backdropImage
    self.releaseDate = releaseDate
    self.rating = rating
    self.metadata = metadata
    self.detail = detail
  }

  public func copyWith(
    id: String? = nil,
    movieId: Int? = nil,
    title: String? = nil,
    description: String? = nil,
    posterImage: String? = nil,
    backdropImage: String? = nil,
    releaseDate: String? = nil,
    metadata: String? = nil,
    rating: Double? = nil,
    detail: MovieDetailEntityModel? = nil
  ) -> MovieEntityModel {
    .init(
      id: id ?? self.id,
      movieId: movieId ?? self.movieId,
      title: title ?? self.title,
      description: description ?? self.description,
      posterImage: posterImage ?? self.posterImage,
      backdropImage: backdropImage ?? self.backdropImage,
      releaseDate: releaseDate ?? self.releaseDate,
      metadata: metadata ?? self.metadata,
      rating: rating ?? self.rating,
      detail: detail ?? self.detail
    )
  }

  public func makeRemoteDTO() -> MovieResponse.Result {
    guard
      let data = JsonResolver.createData(fromString: metadata),
      let dto = JsonResolver.decodeJson(
        from: data,
        outputType: MovieResponse.Result.self
      )
    else {
      return .makeEmpty()
    }
    return dto
  }

  public static func mapFromMovieRemoteDTO(_ model: MovieResponse.Result) -> MovieEntityModel {
    return MovieEntityModel(
      id: "\(model.id)",
      movieId: model.id,
      title: model.title,
      description: model.overview,
      posterImage: model.posterPath,
      backdropImage: model.backdropPath,
      releaseDate: model.releaseDate,
      metadata: model.makeMetadata(),
      rating: model.voteAverage,
      detail: MovieDetailEntityModel.makeEmpty()
    )
  }

  public static func makeEmpty() -> MovieEntityModel {
    .init(
      id: UUID().uuidString,
      movieId: -1,
      title: "",
      description: "",
      posterImage: "",
      backdropImage: "",
      releaseDate: "",
      metadata: "",
      rating: 0,
      detail: MovieDetailEntityModel.makeEmpty()
    )
  }

}


extension MovieEntityModel {

  public static var samples: [MovieEntityModel] {
    guard
      let data = JsonResolver.readJsonFileFromResource(
      bundle: Bundle.module,
      fileName: "movie_list"
    ),
      let model = JsonResolver.decodeJson(from: data, outputType: MovieResponse.self)
    else {
      return []
    }
    return model.results.map { MovieEntityModel.mapFromMovieRemoteDTO($0) }
  }
}
