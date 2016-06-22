//
//  ChannelsViewController.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 15/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableChannels: UITableView!
    var channels: NSMutableArray?
    let newChannel: UITextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableChannels.dataSource = self
        tableChannels.delegate = self
        
        self.setInterface()
        let app:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        channels = app.ortc?.channels
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChannelsViewController.newMessage), name: "newMessage", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableChannels.reloadData()
    }
    
    func newMessage()
    {
        tableChannels.reloadData()
    }
    
    
    func setInterface(){
        self.title = "Chat Rooms"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChannelsViewController.edit))
        self.tableChannels.backgroundView = UIImageView(image: UIImage(named: "background.png"))
    }
    
    func edit(){
        tableChannels.editing = true;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChannelsViewController.endEdit))
        tableChannels.reloadData()
    }

    func endEdit(){
        tableChannels.editing = false;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChannelsViewController.edit))
        tableChannels.reloadData()
    }
    
    
    func saveChannel(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let temp:NSArray = app.ortc!.channelsIndex!.allKeys
        temp.writeToFile(documentsPath.stringByAppendingString("/channels.plist"), atomically: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if tableView.editing && indexPath.row == channels!.count
        {
            return UITableViewCellEditingStyle.Insert
        }
        else{
            return UITableViewCellEditingStyle.Delete
        }
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Insert
        {
            let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            app.ortc?.subscribeChannel(newChannel.text!)
            let channel:Channel = Channel(name: newChannel.text!)
            app.ortc?.channels?.addObject(channel)
            app.ortc?.channelsIndex?.setObject(channel, forKey: channel.name!)
            
            newChannel.text = ""
            saveChannel()
        }else if editingStyle == UITableViewCellEditingStyle.Delete{
            
            let channel:Channel = channels!.objectAtIndex(indexPath.row) as! Channel
            let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            app.ortc?.channels?.removeObject(channel)
            app.ortc?.channelsIndex?.removeObjectForKey(channel.name!)
            saveChannel()
        }
        tableChannels.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if cell == nil
        {
            cell = UITableViewCell()
        }
        
        cell?.backgroundColor = UIColor.clearColor()
        
        if tableChannels.editing && indexPath.row == channels!.count
        {
            newChannel.frame = CGRect(x: 10, y: 8, width: 250, height: cell!.frame.size.height - 20)
            newChannel.placeholder = "Enter Channel Name Here"
            newChannel.delegate = self
            newChannel.borderStyle = UITextBorderStyle.RoundedRect
            newChannel.font = UIFont(name: "Helvetica Neue", size: 16.0)
            
            cell?.contentView.addSubview(newChannel)
            return cell!
        }
        
        let subViews: NSArray = cell!.contentView.subviews as NSArray
        for i in 0 ..< subViews.count
        {
            let subview:UIView = subViews.objectAtIndex(i) as! UIView
            subview.removeFromSuperview()
        }
        
        let channel = channels!.objectAtIndex(indexPath.row) as? Channel
        cell?.textLabel?.text = channel!.getName()
        cell?.textLabel?.textColor = UIColor.whiteColor()
        
        if channel!.unRead > 0 {
            
            let unread:Int = channel!.unRead!
            let unreadMsg:String = String(unread)
            
            let unreadLabel:UILabel = UILabel();
            unreadLabel.font = UIFont(name: "Helvetica Neue", size: 14)
            unreadLabel.text = unreadMsg;
            unreadLabel.textColor = UIColor.whiteColor()
            unreadLabel.backgroundColor = UIColor(red: 220/255.0, green: 55/255.0, blue: 35/255.0, alpha: 1.0)
            unreadLabel.numberOfLines = 1
            unreadLabel.layer.borderColor = UIColor.darkGrayColor().CGColor;
            unreadLabel.layer.borderWidth = 1.0;
            unreadLabel.layer.cornerRadius = 6.0;
            unreadLabel.textAlignment = NSTextAlignment.Center;
            
            let maximumLabelSize:CGFloat = 20.0;
            let expectedLabelSize:CGSize = unreadMsg.sizeWithAttributes([NSFontAttributeName: unreadLabel.font.fontWithSize(maximumLabelSize)])
            
            unreadLabel.frame = CGRectMake(250, (cell!.contentView.frame.size.height - (expectedLabelSize.height + 5))/2, expectedLabelSize.width + 5, expectedLabelSize.height + 5);
            cell!.contentView.addSubview(unreadLabel);
        }
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rows:Int = channels!.count
        if tableView.editing == true {
            return rows + 1
        }
        
        return channels!.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destination = segue.destinationViewController as! MessagesViewController
        let selected = tableChannels.indexPathForSelectedRow
        if selected != nil{
            destination.channel = channels!.objectAtIndex((selected?.row)!) as? Channel
            tableChannels.deselectRowAtIndexPath(tableChannels.indexPathForSelectedRow!, animated: false)
        }
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        return true
//    }

}
