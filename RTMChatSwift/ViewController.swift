//
//  ViewController.swift
//  RTMChatSwift
//
//  Created by Joao Caixinha on 14/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textNick: UITextField!
    @IBOutlet weak var buttonChatRooms: UIButton!
    @IBOutlet weak var labelState: UILabel!    
    @IBOutlet weak var labelWelcome: UILabel!
    var isConnect:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "RTMChat swift"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.ortcConnect), name: "ortcConnect", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.setInterface), name: "noConnection", object: nil)
        self.disableBt()
        self.setInterface()
        
        textNick.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        NSUserDefaults.standardUserDefaults().setValue(textNick.text, forKey: "NickName")
        NSUserDefaults.standardUserDefaults().synchronize()
        textField.resignFirstResponder()
        self.setConnectState()
        return true
    }
    
    func setInterface()
    {
        let user:String? = NSUserDefaults.standardUserDefaults().objectForKey("NickName") as! String?
        buttonChatRooms.layer.masksToBounds = true
        buttonChatRooms.layer.cornerRadius = 6
        buttonChatRooms.layer.masksToBounds = true
        buttonChatRooms.clipsToBounds = true
        
        
        labelState.layer.masksToBounds = true
        labelState.layer.cornerRadius = 6
        labelState.layer.masksToBounds = true
        labelState.clipsToBounds = true
        
        if user != nil
        {
            textNick.hidden = true
            
            labelWelcome.text = "Welcome " + user!
            labelWelcome.hidden = false
            if isConnect {
                self.enableBt()
            }

        }else
        {
            textNick.hidden = false
            labelWelcome.hidden = true
        }
        
                labelState.layer.borderColor = UIColor.blackColor().CGColor
        labelState.layer.borderWidth = 1
        labelState.backgroundColor = UIColor.grayColor()
        labelState.text = "Not connected"
    }
    
    func disableBt(){
        buttonChatRooms.enabled = false
        buttonChatRooms.backgroundColor = UIColor.grayColor()
        buttonChatRooms.layer.borderColor = UIColor.blackColor().CGColor
        buttonChatRooms.layer.borderWidth = 1
    }
    
    func enableBt(){
        buttonChatRooms.enabled = true
        buttonChatRooms.backgroundColor = UIColor.lightGrayColor()
    }
    
    func setConnectState(){
        let user:String? = NSUserDefaults.standardUserDefaults().objectForKey("NickName") as! String?
        if user != nil
        {
            textNick.hidden = true
            
            labelWelcome.text = "Welcome " + user!
            labelWelcome.hidden = false
            if isConnect {
                self.enableBt()
            }

            if isConnect {
                self.enableBt()
            }
            
        }

    }

    func ortcConnect()
    {
        self.isConnect = true
        self.setConnectState()

        labelState.text = "Ortc is connected"
        labelState.backgroundColor = UIColor.lightGrayColor()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }


}

