//
//  ViewController.swift
//  Example
//
//  Created by John Lima on 03/03/19.
//  Copyright © 2019 thejohnlima. All rights reserved.
//

import UIKit

class DashViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

  private let viewModel = ViewModel()

  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addObservers()
    updateUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.fetchData()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: - Private Methods
  private func updateUI() {
    self.tableView.tableFooterView = UIView(frame: .zero)
  }

  private func addObservers() {
    viewModel.observable.didChange = { [weak self] status in
      DispatchQueue.main.async {
        switch status {
        case .load:
          self?.tableView.isHidden = false
          self?.tableView.reloadData()
          self?.activityIndicatorView.stopAnimating()
        case .loading:
          self?.activityIndicatorView.startAnimating()
          self?.tableView.isHidden = true
        default:
          self?.activityIndicatorView.stopAnimating()
          self?.tableView.isHidden = false
        }
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension DashViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "\(DashTableViewCell.self)", for: indexPath) as! DashTableViewCell
    cell.setup(viewModel.observable.value, atIndex: indexPath)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension DashViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return DashTableViewCell.height
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
