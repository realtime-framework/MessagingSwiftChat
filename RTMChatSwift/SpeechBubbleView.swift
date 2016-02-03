//
//  SpeechBubbleView.swift
//  RTMChatSwift
//
//  Created by joao caixinha on 02/02/16.
//  Copyright © 2016 Internet Business Technologies. All rights reserved.
//

import Foundation
import UIKit

var font: UIFont? = nil

var lefthandImage: UIImage? = nil

var righthandImage: UIImage? = nil

let VertPadding: CGFloat = 4

// additional padding around the edges
let HorzPadding: CGFloat = 4

let TextLeftMargin: CGFloat = 19

// insets for the text
let TextRightMargin: CGFloat = 7

let TextTopMargin: CGFloat = 11

let TextBottomMargin: CGFloat = 11

let MinBubbleWidth: CGFloat = 50

// minimum width of the bubble
let MinBubbleHeight: CGFloat = 40

// minimum height of the bubble
let WrapWidth: CGFloat = 200

// maximum width of text in the bubble
enum BubbleType : Int {
    case Lefthand = 0
    case Righthand
}

class SpeechBubbleView: UIView {
    var text:NSString = ""
    var bubbleType:BubbleType?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func initialize() {
        if self == SpeechBubbleView.self {
            font = UIFont.systemFontOfSize(UIFont.systemFontSize())
            lefthandImage = UIImage(named: "ballon_left.png")!.stretchableImageWithLeftCapWidth(20, topCapHeight: 19)
            righthandImage = UIImage(named: "ballon_right.png")!.stretchableImageWithLeftCapWidth(20, topCapHeight: 19)
        }
    }
    
    class func sizeForText(text: NSString) -> CGSize {
        let textSize: CGSize = text.boundingRectWithSize(CGSizeMake(WrapWidth, 9999), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font!], context: nil).size
        //sizeWithFont(font!, constrainedToSize: CGSizeMake(WrapWidth, 9999), lineBreakMode: NSLineBreakMode.ByWordWrapping)
        var bubbleSize: CGSize = CGSize()
        bubbleSize.width = textSize.width + TextLeftMargin + TextRightMargin
        bubbleSize.height = textSize.height + TextTopMargin + TextBottomMargin
        if bubbleSize.width < MinBubbleWidth {
            bubbleSize.width = MinBubbleWidth
        }
        if bubbleSize.height < MinBubbleHeight {
            bubbleSize.height = MinBubbleHeight
        }
        bubbleSize.width += HorzPadding * 2
        bubbleSize.height += VertPadding * 2
        return bubbleSize
    }
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor!.setFill()
        UIRectFill(rect)
        let bubbleRect: CGRect = CGRectInset(self.bounds, VertPadding, HorzPadding)
        var textRect: CGRect = CGRect()
        textRect.origin.y = bubbleRect.origin.y + TextTopMargin
        textRect.size.width = bubbleRect.size.width - TextLeftMargin - TextRightMargin
        textRect.size.height = bubbleRect.size.height - TextTopMargin - TextBottomMargin
        if bubbleType == BubbleType.Lefthand {
            lefthandImage!.drawInRect(bubbleRect)
            textRect.origin.x = bubbleRect.origin.x + TextLeftMargin
        }
        else {
            righthandImage!.drawInRect(bubbleRect)
            textRect.origin.x = bubbleRect.origin.x + TextRightMargin
        }
        UIColor.blackColor().set()
        text.drawInRect(textRect, withAttributes: [NSFontAttributeName:font!])
    }
    
    func setText(newText: NSString, bubbleType newBubbleType: BubbleType) {
        self.text = newText.copy() as! NSString
        self.bubbleType = newBubbleType
        self.setNeedsDisplay()
    }
}