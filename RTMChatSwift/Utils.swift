//
//  Utils.swift
//  RTMChatSwift
//
//  Created by joao caixinha on 02/02/16.
//  Copyright © 2016 Internet Business Technologies. All rights reserved.
//

import Foundation

func jsonDictionaryFromString(text: String) -> NSDictionary? {
    let jsonData: NSData = text.dataUsingEncoding(NSUTF8StringEncoding)!
    var dict:NSDictionary?
    do{
        dict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
        return dict
    }catch {
        return nil
    }
}

func jsonStringFromDictionary(dict: NSDictionary) -> String? {
    var jsonData: NSData?
    do{
        jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
        return String(data: jsonData!, encoding: NSUTF8StringEncoding)
    }catch {
        return nil
    }
    
}