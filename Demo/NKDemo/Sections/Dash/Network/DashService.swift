//
//  DashService.swift
//  Demo
//
//  Created by John Lima on 04/03/19.
//  Copyright © 2019 limadeveloper. All rights reserved.
//

import Foundation
import BaseNetworkKit

final class DashService: NKBaseService<DashAPI> {
  func fetchGames(page: Int, limit: Int, completion: @escaping NKCommon.ResultType<Model>) {
    let requestModel = ModelRequest(offset: "\(page)", limit: "\(limit)")
    fetch(.topGames(requestModel), dataType: Model.self, completion: completion)
  }
}
