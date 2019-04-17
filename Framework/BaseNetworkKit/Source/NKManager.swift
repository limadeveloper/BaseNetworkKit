//
//  NKManager.swift
//  BaseNetworkKit
//
//  Created by John Lima on 16/04/19.
//  Copyright © 2019 limadeveloper. All rights reserved.
//

import Foundation

public class NKManager: NSObject {

  // MARK: - Properties
  public static let shared = NKManager()

  public var environment: NKEnvironment = .production
}
