//
//  Model.swift
//  Demo
//
//  Created by John Lima on 04/03/19.
//  Copyright © 2019 limadeveloper. All rights reserved.
//

import Foundation
import BaseNetworkKit

struct Model: NKCodable {
  let topGames: [GameModel]

  enum CodingKeys: String, CodingKey {
    case topGames = "top"
  }

  struct GameModel: NKCodable {
    let game: Game
    let viewers: Int
  }

  struct Game: NKCodable {
    let name: String
    let image: Image
  }
}

extension Model.Game {
  struct Image: NKCodable {
    let photo: String
  }

  enum CodingKeys: String, CodingKey {
    case name
    case image = "box"
  }
}

extension Model.Game.Image {
  enum CodingKeys: String, CodingKey {
    case photo = "medium"
  }
}

struct ModelRequest: NKCodable {
  let offset: String
  let limit: String
}
