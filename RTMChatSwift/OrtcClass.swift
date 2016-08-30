//
//  OrtcClass.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 15/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit
import RealtimeMessaging_iOS_Swift

class OrtcClass: NSObject, OrtcClientDelegate{
    let APPKEY = "INSERT_YOUR_APP_KEY"
    let TOKEN = "TOKEN"
    let METADATA = "METADATA"
    let URL = "http://ortc-developers.realtime.co/server/2.1/"
    
    var ortc: OrtcClient?
    var onMessage:AnyObject?
    
    var channels:NSMutableArray?
    var channelsIndex:NSMutableDictionary?
    
    func connect()
    {
        self.ortc = OrtcClient.ortcClientWithConfig(self)
        self.ortc!.connectionMetadata = METADATA
        self.ortc!.clusterUrl = URL
        
        self.ortc!.connect(APPKEY, authenticationToken: TOKEN)
        channels = NSMutableArray()
        channelsIndex = NSMutableDictionary()
        loadChannels()
    }
    
    
    func subscribeChannel(channel:String)
    {
        self.ortc!.subscribeWithNotifications(channel, subscribeOnReconnected: true, onMessage: { (ortcClient:OrtcClient!, channel:String!, message:String!) -> Void in
            self.processMessage(channel, message: message)
        })

    }
    
    func processMessage(channel:String!, message:String!){
        let messageArray:NSArray = message.componentsSeparatedByString(":")
        
        let jsonMessage:NSMutableDictionary = NSMutableDictionary()
        
        jsonMessage.setObject(messageArray.objectAtIndex(0), forKey: "NickName")
        jsonMessage.setObject(messageArray.objectAtIndex(1), forKey: "Message")
        jsonMessage.setObject(NSDate(), forKey: "Date")
        
        let nick:String = NSUserDefaults.standardUserDefaults().objectForKey("NickName") as! String
        let from:String = jsonMessage.objectForKey("NickName") as! String
        
        if from == nick
        {
            jsonMessage.setObject(true, forKey: "isFromUser")
        }else{
            jsonMessage.setObject(false, forKey: "isFromUser")
        }
        
        let channelRef:Channel! = self.channelsIndex!.objectForKey(channel as String) as! Channel
        channelRef.unRead! += 1;
        channelRef.messages?.addObject(jsonMessage)
        NSNotificationCenter.defaultCenter().postNotificationName("newMessage", object: nil, userInfo: jsonMessage as [NSObject : AnyObject])
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
    
    
    /**
     * Occurs when the client connects.
     *
     * @param ortc The ORTC object.
     */
    func onConnected(ortc: OrtcClient){
        NSLog("CONNECTED")
        NSNotificationCenter.defaultCenter().postNotificationName("ortcConnect", object: nil)
        
        for var i = 0 ; i < channels?.count; i += 1
        {
            let channel:Channel = channels?.objectAtIndex(i) as! Channel
            subscribeChannel(channel.name! as String)
        }
    }
    /**
     * Occurs when the client disconnects.
     *
     * @param ortc The ORTC object.
     */
    
    func onDisconnected(ortc: OrtcClient){
    
    }
    /**
     * Occurs when the client subscribes to a channel.
     *
     * @param ortc The ORTC object.
     * @param channel The channel name.
     */
    
    func onSubscribed(ortc: OrtcClient, channel: String){
        NSLog("did subscribe %@", channel)
    }
    /**
     * Occurs when the client unsubscribes from a channel.
     *
     * @param ortc The ORTC object.
     * @param channel The channel name.
     */
    
    func onUnsubscribed(ortc: OrtcClient, channel: String){
    
    }
    /**
     * Occurs when there is an exception.
     *
     * @param ortc The ORTC object.
     * @param error The occurred exception.
     */
    
    func onException(ortc: OrtcClient, error: NSError){
        let desc:String? = ((error.userInfo as NSDictionary).objectForKey("NSLocalizedDescription") as? String)
        if desc != nil && desc == "Unable to get URL from cluster (http://ortc-developers.realtime.co/server/2.1/)" || desc == "Unable to get URL from cluster (https://ortc-developers.realtime.co/server/ssl/2.1/)"
        {
            NSNotificationCenter.defaultCenter().postNotificationName("noConnection", object: nil)
            NSLog("%@", desc!)
        }
        
    }
    /**
     * Occurs when the client attempts to reconnect.
     *
     * @param ortc The ORTC object.
     */
    
    func onReconnecting(ortc: OrtcClient){
    
    }
    /**
     * Occurs when the client reconnects.
     *
     * @param ortc The ORTC object.
     */
    
    func onReconnected(ortc: OrtcClient){
        NSNotificationCenter.defaultCenter().postNotificationName("ortcConnect", object: nil)
    }
    

    


    
    
    
    
    
    
    
}
