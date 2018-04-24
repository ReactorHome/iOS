//
//  Result.swift
//  Reactor - Networking
//
//  Created by Reiker Seiffe on 2/5/18.
//  Copyright © 2018 ReikerSeiffe.com. All rights reserved.
//

import Foundation

import Foundation

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
