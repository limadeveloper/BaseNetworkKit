//
//  ViewModel.swift
//  Example
//
//  Created by John Lima on 05/03/19.
//  Copyright © 2019 thejohnlima. All rights reserved.
//

import Foundation
import ObservableKit

class ViewModel {

  // MARK: - Properties
  private let requester = DashService()

  let observable: OKObservable<OKState<Model, Error?>> = OKObservable(.loading)
  var items: [Model.GameModel] = []

  // MARK: - Public Methods
  func fetchData() {
    self.observable.value = .loading
    self.items = []
    requester.fetchGames(page: 0, limit: 30) { result in
      switch result {
      case .success(_, let model):
        let games = model.topGames
        self.items = games
        self.observable.value = .load(data: model)
      case .failure(let error):
        self.items = []
        self.observable.value = .errored(error: error)
      }
    }
  }
}
