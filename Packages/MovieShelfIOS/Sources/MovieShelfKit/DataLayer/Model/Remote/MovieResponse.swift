//
//  MovieResponse.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation
import BZUtil


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
    self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 0
    self.results = try container.decodeIfPresent([MovieResponse.Result].self, forKey: .results) ?? []
    self.totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
    self.totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
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
      self.adult = try container.decodeIfPresent(Bool.self, forKey: MovieResponse.Result.CodingKeys.adult) ?? false
      self.backdropPath = try container.decodeIfPresent(String.self, forKey: MovieResponse.Result.CodingKeys.backdropPath) ?? ""
      self.genreIDS = try container.decodeIfPresent([Int].self, forKey: MovieResponse.Result.CodingKeys.genreIDS) ?? []
      self.id = try container.decodeIfPresent(Int.self, forKey: MovieResponse.Result.CodingKeys.id) ?? -1
      self.originalLanguage = try container.decodeIfPresent(String.self, forKey: MovieResponse.Result.CodingKeys.originalLanguage) ?? ""
      self.originalTitle = try container.decodeIfPresent(String.self, forKey: MovieResponse.Result.CodingKeys.originalTitle) ?? ""
      self.overview = try container.decodeIfPresent(String.self, forKey: MovieResponse.Result.CodingKeys.overview) ?? ""
      self.popularity = try container.decodeIfPresent(Double.self, forKey: MovieResponse.Result.CodingKeys.popularity) ?? 0
      self.posterPath = try container.decodeIfPresent(String.self, forKey: MovieResponse.Result.CodingKeys.posterPath) ?? ""
      self.releaseDate = try container.decodeIfPresent(String.self, forKey: MovieResponse.Result.CodingKeys.releaseDate) ?? ""
      self.title = try container.decodeIfPresent(String.self, forKey: MovieResponse.Result.CodingKeys.title) ?? ""
      self.video = try container.decodeIfPresent(Bool.self, forKey: MovieResponse.Result.CodingKeys.video) ?? false
      self.voteAverage = try container.decodeIfPresent(Double.self, forKey: MovieResponse.Result.CodingKeys.voteAverage) ?? 0
      self.voteCount = try container.decodeIfPresent(Int.self, forKey: MovieResponse.Result.CodingKeys.voteCount) ?? -1
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

    public func makeMetadata() -> String {
      guard
        let jsonData = try? JSONEncoder().encode(self)
      else {
        return ""
      }

      let json = JsonResolver.parseDataToJson(jsonData)
      guard !json.isEmpty else {
        return ""
      }

      return JsonResolver.encodeToJson(dictionary: json)
    }

    public static func makeEmpty() -> MovieResponse.Result {
      .init(
        adult: false,
        backdropPath: "",
        genreIDS: [],
        id: 0,
        originalLanguage: "",
        originalTitle: "",
        overview: "",
        popularity: 0,
        posterPath: "",
        releaseDate: "",
        title: "",
        video: false,
        voteAverage: 0,
        voteCount: 0
      )
    }
  }
}
