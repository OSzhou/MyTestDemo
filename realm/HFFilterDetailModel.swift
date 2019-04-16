//
//  HFFilterDetailModel.swift
//  heyfive
//
//  Created by Zhouheng on 2019/3/14.
//  Copyright © 2019年 tataUFO. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class HFFilterDetailModel: Object {
    
    @objc dynamic var data: Data = Data()
    
    init(userData: Com_Heyfive_Proto_BriefUser) {
        self.data = try! userData.serializedData()
        super.init()
    }
    
    init(filterData: Com_Heyfive_Proto_Account_Response10016.DataMessage) {
        self.data = try! filterData.serializedData()
        super.init()
    }
    
    class func briefUser(userData: Data) -> Com_Heyfive_Proto_BriefUser {
        
        return try! Com_Heyfive_Proto_BriefUser(serializedData: userData)
        
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
}
