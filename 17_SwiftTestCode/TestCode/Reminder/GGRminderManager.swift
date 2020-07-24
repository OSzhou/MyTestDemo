//
//  GGRminderManager.swift
//  TestCode
//
//  Created by Zhouheng on 2020/7/24.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit
import EventKit

class GGRminderManager: NSObject {
    static let shared: GGRminderManager = GGRminderManager()
    let eventDB = EKEventStore()
    
}
