//
//  DashTableViewCell.swift
//  Example
//
//  Created by John Lima on 05/03/19.
//  Copyright © 2019 thejohnlima. All rights reserved.
//

import ObservableKit
import UIKit

class DashTableViewCell: UITableViewCell {

  // MARK: - Constants
  static let height: CGFloat = 190

  // MARK: - Properties
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    updateUI()
  }

  // MARK: - Public Methods
  func setup(_ state: OKState<Model, Error?>, atIndex: IndexPath) {
    switch state {
    case .load(let model):
      titleLabel.text = model.topGames[atIndex.row].game.name
      guard let imageURL = URL(string: model.topGames[atIndex.row].game.image.photo) else { return }
      photoImageView.loadImage(imageURL)
    default:
      titleLabel.text = nil
      photoImageView.image = nil
    }
  }

  // MARK: - Private Methods
  private func updateUI() {
    photoImageView.layer.cornerRadius = 10
    photoImageView.clipsToBounds = true
  }
}
