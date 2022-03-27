//
//  ETCDItem.swift
//  etcd
//
//  Created by FaceBook on 2022/3/27.
//  Copyright © 2022 Workpiece. All rights reserved.
//

import Foundation

class ETCDItem {
  var value: String
  var children: [ETCDItem] = []
  weak var parent: ETCDItem?

  init(value: String) {
    self.value = value
  }
    
  func add(child: ETCDItem) {
    children.append(child)
    child.parent = self
  }
}
