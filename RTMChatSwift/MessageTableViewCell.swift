//
//  MessageTableViewCell.swift
//  RTMChatSwift
//
//  Created by joao caixinha on 02/02/16.
//  Copyright © 2016 Internet Business Technologies. All rights reserved.
//

import Foundation
import UIKit

var color: UIColor? = nil

class MessageTableViewCell: UITableViewCell {
    
    var bubbleView:SpeechBubbleView?
    var label:UILabel?
    
    override class func initialize() {
        if self == MessageTableViewCell.self {
            color = UIColor(red: 220 / 255.0, green: 225 / 255.0, blue: 240 / 255.0, alpha: 1.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .None
            // Create the speech bubble view
            self.bubbleView = SpeechBubbleView(frame: CGRectZero)
            //_bubbleView.backgroundColor = color;
            self.bubbleView!.backgroundColor = UIColor.clearColor()
            self.bubbleView!.opaque = true
            self.bubbleView!.clearsContextBeforeDrawing = false
            self.bubbleView!.contentMode = .Redraw
            self.bubbleView!.autoresizingMask = UIViewAutoresizing.None
            self.contentView.addSubview(bubbleView!)
            // Create the label
            self.label = UILabel(frame: CGRectZero)
            //_label.backgroundColor = color;
            self.label!.backgroundColor = UIColor.clearColor()
            self.label!.opaque = true
            self.label!.clearsContextBeforeDrawing = false
            self.label!.contentMode = .Redraw
            self.label!.autoresizingMask = UIViewAutoresizing.None
            self.label!.font = UIFont.systemFontOfSize(13)
            self.label!.textColor = UIColor(red: 64 / 255.0, green: 64 / 255.0, blue: 64 / 255.0, alpha: 1.0)
            self.contentView.addSubview(label!)
    }
    
    override func layoutSubviews() {
        // This is a little trick to set the background color of a table view cell.
        super.layoutSubviews()
        //self.backgroundColor = color;
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setMessage(message: [NSObject : AnyObject]) {
        var point: CGPoint = CGPointZero
        // We display messages that are sent by the user on the left-hand side of
        // the screen. Incoming messages are displayed on the right-hand side.
        var senderName: String
        var bubbleType: BubbleType
        let bubbleSize: CGSize = SpeechBubbleView.sizeForText((message["Message"] as! String))
        if ((message["isFromUser"]?.boolValue) == false)  {
            bubbleType = BubbleType.Lefthand
            senderName = (message["NickName"] as! String)
            self.label!.textAlignment = .Left
        }
        else {
            bubbleType = BubbleType.Righthand
            senderName = (message["NickName"] as! String)
            point.x = self.bounds.size.width - bubbleSize.width
            self.label!.textAlignment = .Right
        }
        // Resize the bubble view and tell it to display the message text
        var rect: CGRect = CGRect()
        rect.origin = point
        rect.size = bubbleSize
        self.bubbleView!.frame = rect
        bubbleView!.setText((message["Message"] as! String), bubbleType: bubbleType)
        // Format the message date
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy, HH:mm"
        let dateString: String = formatter.stringFromDate((message["Date"] as! NSDate))
        // Set the sender's name and date on the label
        self.label!.text = "\(senderName) @ \(dateString)"
        self.label!.textColor = UIColor.whiteColor()
        label!.sizeToFit()
        self.label!.frame = CGRectMake(8, bubbleSize.height, self.contentView.bounds.size.width - 16, 16)
    }
}