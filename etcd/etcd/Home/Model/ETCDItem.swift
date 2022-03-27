//
//  ETCDItem.swift
//  etcd
//
//  Created by FaceBook on 2022/3/27.
//  Copyright © 2022 Workpiece. All rights reserved.
//

import Foundation

class ETCDItem {
  var directory: String
  var fileValue: String?
  var children: [ETCDItem] = []
  weak var parent: ETCDItem?

  init(directory: String) {
    self.directory = directory
  }
    
  func add(child: ETCDItem) {
    children.append(child)
    child.parent = self
  }
}
