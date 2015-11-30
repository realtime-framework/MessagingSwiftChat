//
//  ComposeViewController.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 16/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var navController: UINavigationBar!
    @IBOutlet weak var textAreaMessage: UITextView!
    var channel:Channel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textAreaMessage.delegate = self
        setInterface()
        countRemaning()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        textAreaMessage.becomeFirstResponder()
    }
    
    
    func setInterface(){
        let leftItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        let rightItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
        let navItem = UINavigationItem(title: "none")
        navItem.leftBarButtonItem = leftItem
        navItem.rightBarButtonItem = rightItem
        
        navController.pushNavigationItem(navItem, animated: false)
        
    }
    
    func save(){
        let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let ortc:OrtcClient = app.ortc!.ortc!
        
        let nick:String = NSUserDefaults.standardUserDefaults().objectForKey("NickName") as! String
        
        let messageString:NSString = nick + ":" + textAreaMessage.text
        
        ortc.send(channel!.name, message: messageString as String)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return countRemaning()
    }
    
    func countRemaning() -> Bool{
        let text = textAreaMessage.text
        let remaming = 260 - text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        navController.topItem?.title =  "\(remaming) Remaning"
        
        if remaming > 0{
            return true
        }else{
            return false
        }

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
