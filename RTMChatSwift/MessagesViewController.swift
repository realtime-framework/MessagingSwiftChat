//
//  MessagesViewController.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 16/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableMessages: UITableView!
    @IBOutlet weak var labelNoMessages: UILabel!
    var channel:Channel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableMessages.dataSource = self
        tableMessages.delegate = self
        setInterface()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newMessage", name: "newMessage", object: nil)
    }
    
    
    func newMessage(){
        tableMessages.reloadData()
    }

    func setInterface(){
        self.title = channel!.getName()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "edit")
        self.tableMessages.backgroundView = UIImageView(image: UIImage(named: "background.png"))
    }
    
    func edit(){
        let viewController:ComposeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Compose") as! ComposeViewController
        viewController.channel = channel
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if channel!.messages!.count > 0
        {
            labelNoMessages.hidden = true
        }
        channel!.unRead! = 0;
        return channel!.messages!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier = "MessageCellIdentifier"
        
        var cell:MessageTableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? MessageTableViewCell
        
        if cell == nil
        {
            cell = MessageTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        cell?.backgroundColor = UIColor.clearColor()
        
        let message:NSDictionary = channel!.messages!.objectAtIndex(indexPath.row) as! NSDictionary
        cell!.setMessage(message as [NSObject : AnyObject])
        
        return cell!

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message:NSDictionary = channel!.messages!.objectAtIndex(indexPath.row) as! NSDictionary
        let bublesize = SpeechBubbleView.sizeForText(message.objectForKey("Message") as! String) as CGSize
        
        return bublesize.height + 16
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
