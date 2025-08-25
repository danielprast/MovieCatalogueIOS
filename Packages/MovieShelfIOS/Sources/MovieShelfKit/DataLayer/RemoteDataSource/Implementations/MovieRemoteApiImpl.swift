//
//  MovieRemoteApiImpl.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation
import BZUtil


public struct MovieRemoteApiImpl {

  private let httpClient: AlamoNetworkService
  private let remoteApiState: RemoteApiState

  public init(remoteApiState: RemoteApiState) {
    httpClient = AlamoNetworkService.shared
    self.remoteApiState = remoteApiState
  }

  // MARK: - • Movie RemoteApi

  public func fetchMovies(params: [String : any Sendable]) async throws -> MovieResponse {
    do {
      let baseUrl = await remoteApiState.baseUrl
      let headers = await remoteApiState.headers
      return try await httpClient.performRequest(
        decodable: MovieResponse.self,
        url: URL(string: baseUrl + ApiEndpoints.discoverMovies.path)!,
        method: .get,
        headers: headers,
        parameters: params.isEmpty ? nil : params,
        encoding: .url
      )
    } catch {
      throw error as! MError
    }
  }

  // MARK: - • Movie Search RemoteApi

  public func fetchSearchMovies(params: [String : any Sendable]) async throws -> MovieResponse {
    do {
      let baseUrl = await remoteApiState.baseUrl
      let headers = await remoteApiState.headers
      return try await httpClient.performRequest(
        decodable: MovieResponse.self,
        url: URL(string: baseUrl + ApiEndpoints.discoverMovies.path)!,
        method: .get,
        headers: headers,
        parameters: params.isEmpty ? nil : params,
        encoding: .url
      )
    } catch {
      throw error as! MError
    }
  }

  // MARK: - • Movie Detail

  public func fetchDetailMovie(id: String) async throws -> MovieDetailResponse {
    do {
      let baseUrl = await remoteApiState.baseUrl
      let headers = await remoteApiState.headers
      return try await httpClient.performRequest(
        decodable: MovieDetailResponse.self,
        url: URL(string: baseUrl + ApiEndpoints.movieDetail(id: id).path)!,
        method: .get,
        headers: headers,
        encoding: .url
      )
    } catch {
      throw error as! MError
    }
  }

}


extension MovieRemoteApiImpl: MovieRemoteApi,
                              MovieSearchRemoteApi,
                              MovieDetailRemoteApi {}
