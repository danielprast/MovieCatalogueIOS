//
//  RemoteApiState.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import Foundation

@MainActor
public final class RemoteApiState {

  private var _baseUrl: String = ""
  private var _headers: [String : String] = [:]
  private var authToken = ""

  public init() {}

  public func update(authToken: String) {
    self.authToken = authToken
  }

  public func update(baseUrl: String) {
    self._baseUrl = baseUrl
  }

  public var baseUrl: String { _baseUrl }

  public var headers: [String : String] {
    if authToken.isEmpty {
      return ["accept": "application/json"]
    }
    return [
      "accept": "application/json",
      "Authorization" : "Bearer \(authToken)"
    ]
  }

}
