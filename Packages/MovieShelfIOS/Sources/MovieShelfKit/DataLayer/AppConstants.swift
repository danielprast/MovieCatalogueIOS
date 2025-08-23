//
//  AppEnv.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 23/08/25.
//

import Foundation


public struct AppEnv {

  public init() {}

  public static func apikey() -> String {
    Bundle.main.object(forInfoDictionaryKey: "APIKEY") as! String
  }
}
