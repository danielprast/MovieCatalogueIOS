//
//  MainDependencyFactory.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation
import MovieShelfKit


@MainActor
public final class MainDependencyFactory {

  public let remoteApiState: RemoteApiState
  public let movieRemoteApi: MovieRemoteApi

  public init() {
    func makeRemoteApiState() -> RemoteApiState {
      let unit = RemoteApiState()
      unit.update(baseUrl: AppEnv.baseUrl())
      unit.update(authToken: AppEnv.tokenKey())
      return unit
    }

    func makeMovieRemoteApi(remoteApiState: RemoteApiState) -> MovieRemoteApi {
      return MovieRemoteApiImpl(remoteApiState: remoteApiState)
    }

    let remoteApiState = makeRemoteApiState()
    self.remoteApiState = remoteApiState
    self.movieRemoteApi = makeMovieRemoteApi(remoteApiState: remoteApiState)
  }

}
