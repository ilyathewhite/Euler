//
//  Utilities.swift
//  EulerSketchOSX
//
//  Created by Ilya Belenkiy on 2/23/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import Foundation

/// Generic Result type
public enum Result<T>: CustomStringConvertible {
   case success(T)
   case failure(Error)
   
   public var description: String {
      switch self {
      case .success(let value):
         return "✓, \(value)"
         
      case .failure(let error):
         return "⨉, \(error)"
      }
   }
}

extension Collection {
   func allMatch(_ predicate: (Iterator.Element) throws -> Bool) rethrows -> Bool {
      return try noneMatch { try !predicate($0) }
   }
   
   func noneMatch(_ predicate: (Iterator.Element) throws -> Bool) rethrows -> Bool {
      return try !contains(where: predicate)
   }
}
