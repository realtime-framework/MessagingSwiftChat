//
//  Channel.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 16/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit

class Channel: NSObject {
    var name:String?
    var messages:NSMutableArray?
    var unRead:Int?
    
    init(name: String)
    {
        super.init()
        self.name = name
        self.messages = NSMutableArray()
        self.unRead = 0;
    }
    
    
    func getName() -> String
    {
        return self.name!
    }
}
