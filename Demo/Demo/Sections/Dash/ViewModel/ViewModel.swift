//
//  ViewModel.swift
//  Demo
//
//  Created by John Lima on 05/03/19.
//  Copyright © 2019 limadeveloper. All rights reserved.
//

import Foundation
import ObservableKit

class ViewModel {

  private let requester = Requester()

  let observable: OKObservable<OKState<Model>> = OKObservable(.loading)
  var items: [Model.GameModel] = []

  func fetchData() {
    self.observable.value = .loading
    self.items = []
    requester.fetchGames(page: 0, limit: 30) { model, error in
      if let error = error {
        self.items = []
        self.observable.value = .errored(error: error)
        return
      }
      guard let model = model else {
        self.items = []
        self.observable.value = .empty
        return
      }
      let games = model.topGames
      self.items = games
      self.observable.value = .load(data: model)
    }
  }
}
