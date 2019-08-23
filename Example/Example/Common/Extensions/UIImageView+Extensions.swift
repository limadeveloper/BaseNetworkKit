//
//  UIImageView+Extensions.swift
//  Example
//
//  Created by John Lima on 05/03/19.
//  Copyright © 2019 thejohnlima. All rights reserved.
//

import UIKit

extension UIImageView {
  func loadImage(_ url: URL) {
    URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data else { return }
      DispatchQueue.main.async { [weak self] in
        self?.image = UIImage(data: data)
      }
    }.resume()
  }
}
