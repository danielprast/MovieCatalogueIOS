//
//  MoveRemoteApiImpl.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation
import BZUtil


public struct MovieRemoteApiImpl: MovieRemoteApi {

  private let httpClient: AlamoNetworkService
  private let remoteApiState: RemoteApiState

  public init(remoteApiState: RemoteApiState) {
    httpClient = AlamoNetworkService.shared
    self.remoteApiState = remoteApiState
  }

  public func fetchMovies() async throws -> MovieResponse {
    do {
      let baseUrl = await remoteApiState.baseUrl
      let headers = await remoteApiState.headers
      return try await httpClient.performRequest(
        decodable: MovieResponse.self,
        url: URL(string: baseUrl + ApiEndpoints.discoverMovies.path)!,
        method: .get,
        headers: headers,
        encoding: .url
      )
    } catch {
      throw error as! MError
    }
  }

}
