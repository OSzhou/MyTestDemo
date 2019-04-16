//
//  HFFilterResultModel.swift
//  heyfive
//
//  Created by Zhouheng on 2019/3/14.
//  Copyright © 2019年 tataUFO. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class HFFilterResultModel: Object {
    /// 筛选条件ID
    @objc dynamic var modelId: Int32 = 0
    /// 筛选结果 -> Data
    @objc dynamic var data: Data = Data()
    
    @objc dynamic var resultList = RLMArray<AnyObject>(objectClassName: HFFilterDetailModel.className())
    
    init(resultData: Com_Heyfive_Proto_Account_Response10016.DataMessage) {
        self.data = try! resultData.serializedData()
        super.init()
    }
    
    class func resultUser(resultData: Data) -> Com_Heyfive_Proto_Account_Response10016.DataMessage {
        
        return try! Com_Heyfive_Proto_Account_Response10016.DataMessage(serializedData: resultData)
        
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
    
    init(_ modelId: Int32, userInfo: [Com_Heyfive_Proto_BriefUser]) {
        
        self.modelId = modelId
        
        for user in userInfo {
            let item = HFFilterDetailModel(userData: user)
            resultList.add(item)
        
        }
        
        super.init()
    }
    
}
