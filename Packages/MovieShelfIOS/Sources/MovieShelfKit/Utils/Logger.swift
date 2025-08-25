//
//  Logger.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 24/08/25.
//

import BZUtil


public func clog(
  _ key: String,
  _ value: Any,
  type: TLogType = .info,
  subsystem: String = "module",
  file: String = #fileID,
  function: String = #function,
  line: Int = #line
) {
  #if DEBUG
  tlog(
    key,
    value,
    type: type,
    subsystem: subsystem,
    file: file,
    function: function,
    line: line
  )
  #endif
}
