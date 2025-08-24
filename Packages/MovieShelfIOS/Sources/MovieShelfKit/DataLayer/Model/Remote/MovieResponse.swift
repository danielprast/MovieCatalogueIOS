//
//  MovieResponse.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation


public struct MovieResponse: Codable, Sendable {
  public let page: Int
  public let results: [Result]
  public let totalPages, totalResults: Int

  public enum CodingKeys: String, CodingKey {
    case page, results
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.page = try container.decode(Int.self, forKey: .page)
    self.results = try container.decode([MovieResponse.Result].self, forKey: .results)
    self.totalPages = try container.decode(Int.self, forKey: .totalPages)
    self.totalResults = try container.decode(Int.self, forKey: .totalResults)
  }

  public init(
    page: Int,
    results: [Result],
    totalPages: Int,
    totalResults: Int
  ) {
    self.page = page
    self.results = results
    self.totalPages = totalPages
    self.totalResults = totalResults
  }

  public struct Result: Codable, Sendable {
    public let adult: Bool
    public let backdropPath: String
    public let genreIDS: [Int]
    public let id: Int
    public let originalLanguage: String
    public let originalTitle, overview: String
    public let popularity: Double
    public let posterPath, releaseDate, title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int

    public enum CodingKeys: String, CodingKey {
      case adult
      case backdropPath = "backdrop_path"
      case genreIDS = "genre_ids"
      case id
      case originalLanguage = "original_language"
      case originalTitle = "original_title"
      case overview, popularity
      case posterPath = "poster_path"
      case releaseDate = "release_date"
      case title, video
      case voteAverage = "vote_average"
      case voteCount = "vote_count"
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<MovieResponse.Result.CodingKeys> = try decoder.container(keyedBy: MovieResponse.Result.CodingKeys.self)
      self.adult = try container.decode(Bool.self, forKey: MovieResponse.Result.CodingKeys.adult)
      self.backdropPath = try container.decode(String.self, forKey: MovieResponse.Result.CodingKeys.backdropPath)
      self.genreIDS = try container.decode([Int].self, forKey: MovieResponse.Result.CodingKeys.genreIDS)
      self.id = try container.decode(Int.self, forKey: MovieResponse.Result.CodingKeys.id)
      self.originalLanguage = try container.decode(String.self, forKey: MovieResponse.Result.CodingKeys.originalLanguage)
      self.originalTitle = try container.decode(String.self, forKey: MovieResponse.Result.CodingKeys.originalTitle)
      self.overview = try container.decode(String.self, forKey: MovieResponse.Result.CodingKeys.overview)
      self.popularity = try container.decode(Double.self, forKey: MovieResponse.Result.CodingKeys.popularity)
      self.posterPath = try container.decode(String.self, forKey: MovieResponse.Result.CodingKeys.posterPath)
      self.releaseDate = try container.decode(String.self, forKey: MovieResponse.Result.CodingKeys.releaseDate)
      self.title = try container.decode(String.self, forKey: MovieResponse.Result.CodingKeys.title)
      self.video = try container.decode(Bool.self, forKey: MovieResponse.Result.CodingKeys.video)
      self.voteAverage = try container.decode(Double.self, forKey: MovieResponse.Result.CodingKeys.voteAverage)
      self.voteCount = try container.decode(Int.self, forKey: MovieResponse.Result.CodingKeys.voteCount)
    }

    public init(
      adult: Bool,
      backdropPath: String,
      genreIDS: [Int],
      id: Int,
      originalLanguage: String,
      originalTitle: String,
      overview: String,
      popularity: Double,
      posterPath: String,
      releaseDate: String,
      title: String,
      video: Bool,
      voteAverage: Double,
      voteCount: Int
    ) {
      self.adult = adult
      self.backdropPath = backdropPath
      self.genreIDS = genreIDS
      self.id = id
      self.originalLanguage = originalLanguage
      self.originalTitle = originalTitle
      self.overview = overview
      self.popularity = popularity
      self.posterPath = posterPath
      self.releaseDate = releaseDate
      self.title = title
      self.video = video
      self.voteAverage = voteAverage
      self.voteCount = voteCount
    }
  }
}
