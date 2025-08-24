//
//  MovieDetailResponse.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 25/08/25.
//

import Foundation


public struct MovieDetailResponse: Codable, Sendable {
  public let adult: Bool
  public let backdropPath: String
  public let budget: Int
  public let genres: [Genre]
  public let homepage: String
  public let id: Int
  public let imdbID: String
  public let originCountry: [String]
  public let originalLanguage, originalTitle, overview: String
  public let popularity: Double
  public let posterPath: String
  public let productionCompanies: [ProductionCompany]
  public let productionCountries: [ProductionCountry]
  public let releaseDate: String
  public let revenue, runtime: Int
  public let spokenLanguages: [SpokenLanguage]
  public let status, tagline, title: String
  public let video: Bool
  public let voteAverage: Double
  public let voteCount: Int

  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case budget, genres, homepage, id
    case imdbID = "imdb_id"
    case originCountry = "origin_country"
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case overview, popularity
    case posterPath = "poster_path"
    case productionCompanies = "production_companies"
    case productionCountries = "production_countries"
    case releaseDate = "release_date"
    case revenue, runtime
    case spokenLanguages = "spoken_languages"
    case status, tagline, title, video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult) ?? false
    self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
    self.budget = try container.decodeIfPresent(Int.self, forKey: .budget) ?? -1
    self.genres = try container.decodeIfPresent([MovieDetailResponse.Genre].self, forKey: .genres) ?? []
    self.homepage = try container.decodeIfPresent(String.self, forKey: .homepage) ?? ""
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
    self.imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID) ?? ""
    self.originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry) ?? []
    self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage) ?? ""
    self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle) ?? ""
    self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
    self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0
    self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
    self.productionCompanies = try container.decodeIfPresent([MovieDetailResponse.ProductionCompany].self, forKey: .productionCompanies) ?? []
    self.productionCountries = try container.decodeIfPresent([MovieDetailResponse.ProductionCountry].self, forKey: .productionCountries) ?? []
    self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
    self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue) ?? -1
    self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime) ?? -1
    self.spokenLanguages = try container.decodeIfPresent([MovieDetailResponse.SpokenLanguage].self, forKey: .spokenLanguages) ?? []
    self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
    self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline) ?? ""
    self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
    self.video = try container.decodeIfPresent(Bool.self, forKey: .video) ?? false
    self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
    self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount) ?? -1
  }

  public init(
    adult: Bool,
    backdropPath: String,
    budget: Int,
    genres: [Genre],
    homepage: String,
    id: Int,
    imdbID: String,
    originCountry: [String],
    originalLanguage: String,
    originalTitle: String,
    overview: String,
    popularity: Double,
    posterPath: String,
    productionCompanies: [ProductionCompany],
    productionCountries: [ProductionCountry],
    releaseDate: String,
    revenue: Int,
    runtime: Int,
    spokenLanguages: [SpokenLanguage],
    status: String,
    tagline: String,
    title: String,
    video: Bool,
    voteAverage: Double,
    voteCount: Int
  ) {
    self.adult = adult
    self.backdropPath = backdropPath
    self.budget = budget
    self.genres = genres
    self.homepage = homepage
    self.id = id
    self.imdbID = imdbID
    self.originCountry = originCountry
    self.originalLanguage = originalLanguage
    self.originalTitle = originalTitle
    self.overview = overview
    self.popularity = popularity
    self.posterPath = posterPath
    self.productionCompanies = productionCompanies
    self.productionCountries = productionCountries
    self.releaseDate = releaseDate
    self.revenue = revenue
    self.runtime = runtime
    self.spokenLanguages = spokenLanguages
    self.status = status
    self.tagline = tagline
    self.title = title
    self.video = video
    self.voteAverage = voteAverage
    self.voteCount = voteCount
  }

  // MARK: - Genre
  public struct Genre: Codable, Sendable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
      self.id = id
      self.name = name
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<MovieDetailResponse.Genre.CodingKeys> = try decoder.container(keyedBy: MovieDetailResponse.Genre.CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: MovieDetailResponse.Genre.CodingKeys.id) ?? -1
      self.name = try container.decodeIfPresent(String.self, forKey: MovieDetailResponse.Genre.CodingKeys.name) ?? ""
    }
  }

  // MARK: - ProductionCompany
  public struct ProductionCompany: Codable, Sendable {
    public let id: Int
    public let logoPath, name, originCountry: String

    enum CodingKeys: String, CodingKey {
      case id
      case logoPath = "logo_path"
      case name
      case originCountry = "origin_country"
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<MovieDetailResponse.ProductionCompany.CodingKeys> = try decoder.container(keyedBy: MovieDetailResponse.ProductionCompany.CodingKeys.self)
      self.id = try container.decodeIfPresent(Int.self, forKey: MovieDetailResponse.ProductionCompany.CodingKeys.id) ?? -1
      self.logoPath = try container.decodeIfPresent(String.self, forKey: MovieDetailResponse.ProductionCompany.CodingKeys.logoPath) ?? ""
      self.name = try container.decodeIfPresent(String.self, forKey: MovieDetailResponse.ProductionCompany.CodingKeys.name) ?? ""
      self.originCountry = try container.decodeIfPresent(String.self, forKey: MovieDetailResponse.ProductionCompany.CodingKeys.originCountry) ?? ""
    }

    public init(
      id: Int,
      logoPath: String,
      name: String,
      originCountry: String
    ) {
      self.id = id
      self.logoPath = logoPath
      self.name = name
      self.originCountry = originCountry
    }
  }

  // MARK: - ProductionCountry
  public struct ProductionCountry: Codable, Sendable {
    public let iso3166_1, name: String

    enum CodingKeys: String, CodingKey {
      case iso3166_1 = "iso_3166_1"
      case name
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<MovieDetailResponse.ProductionCountry.CodingKeys> = try decoder.container(keyedBy: MovieDetailResponse.ProductionCountry.CodingKeys.self)
      self.iso3166_1 = try container.decodeIfPresent(String.self, forKey: MovieDetailResponse.ProductionCountry.CodingKeys.iso3166_1) ?? ""
      self.name = try container.decodeIfPresent(String.self, forKey: MovieDetailResponse.ProductionCountry.CodingKeys.name) ?? ""
    }

    public init(
      iso3166_1: String,
      name: String
    ) {
      self.iso3166_1 = iso3166_1
      self.name = name
    }
  }

  // MARK: - SpokenLanguage
  public struct SpokenLanguage: Codable, Sendable {
    public let englishName, iso639_1, name: String

    enum CodingKeys: String, CodingKey {
      case englishName = "english_name"
      case iso639_1 = "iso_639_1"
      case name
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<MovieDetailResponse.SpokenLanguage.CodingKeys> = try decoder.container(keyedBy: MovieDetailResponse.SpokenLanguage.CodingKeys.self)
      self.englishName = try container.decodeIfPresent(String.self, forKey: MovieDetailResponse.SpokenLanguage.CodingKeys.englishName) ?? ""
      self.iso639_1 = try container.decodeIfPresent(String.self, forKey: MovieDetailResponse.SpokenLanguage.CodingKeys.iso639_1) ?? ""
      self.name = try container.decodeIfPresent(String.self, forKey: MovieDetailResponse.SpokenLanguage.CodingKeys.name) ?? ""
    }

    public init(
      englishName: String,
      iso639_1: String,
      name: String
    ) {
      self.englishName = englishName
      self.iso639_1 = iso639_1
      self.name = name
    }

    public static func makeEmpty() -> SpokenLanguage {
      return .init(
        englishName: "",
        iso639_1: "",
        name: ""
      )
    }
  }
}
