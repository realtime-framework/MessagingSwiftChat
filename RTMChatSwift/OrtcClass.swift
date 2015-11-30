//
//  OrtcClass.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 15/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit

class OrtcClass: NSObject, OrtcClientDelegate{
    let APPKEY = "__YOUR_APPLICATION_KEY__"
    let TOKEN = "TOKEN"
    let METADATA = "METADATA"
    let URL = "http://ortc-developers.realtime.co/server/2.1/"
    
    var ortc: OrtcClient?
    var onMessage:AnyObject?
    
    var channels:NSMutableArray?
    var channelsIndex:NSMutableDictionary?
    func connect()
    {
        self.ortc = OrtcClient.ortcClientWithConfig(self) as? OrtcClient
        self.ortc!.connectionMetadata = METADATA
        self.ortc!.clusterUrl = URL
        
        self.ortc!.connect(APPKEY, authenticationToken: TOKEN)
        channels = NSMutableArray()
        channelsIndex = NSMutableDictionary()
        loadChannels()
    }
    
    
    func onConnected(ortc: OrtcClient!) {
        NSLog("CONNECTED")
        NSNotificationCenter.defaultCenter().postNotificationName("ortcConnect", object: nil)
        
        
        
        for var i = 0 ; i < channels?.count; i++
        {
            let channel:Channel = channels?.objectAtIndex(i) as! Channel
            subscribeChannel(channel.name! as String)
        }
    }
    
    
    func subscribeChannel(channel:String)
    {
        self.ortc!.subscribe(channel, subscribeOnReconnected: true, onMessage: { (ortcClient:OrtcClient!, channel:String!, message:String!) -> Void in
            
            let messageArray:NSArray = message.componentsSeparatedByString(":")
            
            let jsonMessage:NSMutableDictionary = NSMutableDictionary()
            
            jsonMessage.setObject(messageArray.objectAtIndex(0), forKey: "NickName")
            jsonMessage.setObject(messageArray.objectAtIndex(1), forKey: "Message")
            jsonMessage.setObject(NSDate(), forKey: "Date")
            
            let nick:String = NSUserDefaults.standardUserDefaults().objectForKey("NickName") as! String
            let from:String = jsonMessage.objectForKey("NickName") as! String
            
            if from == nick
            {
                jsonMessage.setObject(1, forKey: "isFromUser")
            }else{
                jsonMessage.setObject(0, forKey: "isFromUser")
            }
            
            let channelRef:Channel! = self.channelsIndex!.objectForKey(channel as String) as! Channel
            channelRef.unRead! += 1;
            channelRef.messages?.addObject(jsonMessage)
            NSNotificationCenter.defaultCenter().postNotificationName("newMessage", object: nil, userInfo: jsonMessage as [NSObject : AnyObject])
        })

    }
    
    func loadChannels(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        channels = NSMutableArray(contentsOfFile: documentsPath.stringByAppendingString("/channels.plist"))
        
        if channels == nil
        {
            channels = NSMutableArray()
        }else
        {
            let temp: NSMutableArray = NSMutableArray()
            for obj in channels! as [AnyObject]
            {
                let channel:Channel = Channel(name: obj as! String)
                temp.addObject(channel)
                channelsIndex?.setObject(channel, forKey: obj as! String)
            }
            channels = temp
        }
    }
    
    func onSubscribed(ortc: OrtcClient!, channel: String!) {
        NSLog("did subscribe %@", channel)
    }
    
    func onUnsubscribed(ortc: OrtcClient!, channel: String!) {
        
    }
    
    
    func onDisconnected(ortc: OrtcClient!) {
        
    }
    
    func onException(ortc: OrtcClient!, error: NSError!) {
        
        let desc:String = ((error.userInfo as NSDictionary).objectForKey("NSLocalizedDescription") as? String)!
        if desc == "Unable to get URL from cluster (http://ortc-developers.realtime.co/server/2.1/)" || desc == "Unable to get URL from cluster (https://ortc-developers.realtime.co/server/ssl/2.1/)"
        {
            NSNotificationCenter.defaultCenter().postNotificationName("noConnection", object: nil)
        }
        NSLog("%@", desc)
    }
    
    func onReconnected(ortc: OrtcClient!) {
        NSNotificationCenter.defaultCenter().postNotificationName("ortcConnect", object: nil)
    }
    
    func onReconnecting(ortc: OrtcClient!) {
        
    }

    
    
    
    
    
    
    
}
