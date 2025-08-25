//
//  MainDependencyFactory.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation
import MovieShelfKit
import BZConnectionChecker
import BZUtil


@MainActor
public final class MainDependencyFactory {

  public let connectionReachability: ConnectionReachability
  public let networkConnectionChecker: NetworkConnectionChecker
  public let remoteApiState: RemoteApiState
  public let movieRepository: MovieRepository

  public init() {
    func makeConnectionReachability() -> ConnectionReachability {
      return ConnectionReachability.init()
    }

    func makeNetworkConnectionChecker(connectionReachability: ConnectionReachability) -> NetworkConnectionChecker {
      return NetworkConnectionCheckerImpl_V2.init(reachability: connectionReachability)
    }

    func makeRemoteApiState() -> RemoteApiState {
      let unit = RemoteApiState()
      unit.update(baseUrl: AppEnv.baseUrl())
      unit.update(authToken: AppEnv.tokenKey())
      return unit
    }

    func makeMovieRemoteApi(remoteApiState: RemoteApiState) -> MovieRemoteApi {
      //return FakeMovieRemoteApiImpl()
      return MovieRemoteApiImpl(remoteApiState: remoteApiState)
    }

    func makeMovieRepository(
      movieRemoteApi: MovieRemoteApi,
      movieDetailRemoteApi: MovieDetailRemoteApi,
      networkChecker: NetworkConnectionChecker
    ) -> MovieRepository {
      return MovieRepositoryImpl(
        movieRemoteApi: movieRemoteApi,
        movieDetailRemoteApi: movieDetailRemoteApi,
        networkConnectionChecker: networkChecker
      )
    }

    let connectionReachability = makeConnectionReachability()
    let networkConnectionChecker = makeNetworkConnectionChecker(connectionReachability: connectionReachability)
    let remoteApiState = makeRemoteApiState()
    let movieRemoteApi = makeMovieRemoteApi(remoteApiState: remoteApiState)
    let movieDetailRemoteApi = movieRemoteApi as! MovieDetailRemoteApi
    self.remoteApiState = remoteApiState
    self.movieRepository = makeMovieRepository(
      movieRemoteApi: movieRemoteApi,
      movieDetailRemoteApi: movieDetailRemoteApi,
      networkChecker: networkConnectionChecker
    )
    self.connectionReachability = connectionReachability
    self.networkConnectionChecker = networkConnectionChecker
  }

  func makeMovieViewModel() -> MovieViewModel {
    return MovieViewModel(movieRepository: self.movieRepository)
  }

}
