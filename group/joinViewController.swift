//
//  joinViewController.swift
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/22.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

import UIKit

class joinViewController: UIViewController,UITextFieldDelegate{
    
    var window:UIWindow = UIWindow()
    var _idField:UITextField = UITextField()
    var _pwdField:UITextField = UITextField()
    var joinBtn:UIButton = UIButton()
    func clickLeftButton(){
        self.dismissViewControllerAnimated(true, completion: {
            
            self.window.hidden = true
            
        })
        
    }
    func join(){
        joinBtn.enabled = false
        if(self._idField.text==nil||self._idField.text=="")
        {return}
        var op:OwnerDAO = OwnerDAO()
        var create:servlet = servlet()
        create.manager.POST("http://192.168.1.108:8001/api/join_group/", parameters: ["user_email":op.findAll()[0].email,"group_id":self._idField.text,"group_pwd":self._pwdField.text],  success: {(operation,responseObject) in
            print(responseObject)
            if((responseObject as! NSDictionary).objectForKey("message") as! String == "join group success"){
            //var data = (responseObject as! NSDictionary).objectForKey("data") as! NSDictionary
              //  var group_id =  data.objectForKey("group_id") as! NSNumber
              //  var group_pwd  = data.objectForKey("group_pwd") as! NSString
                
                //缓存
                var alert:UIAlertView = UIAlertView(title: "Success", message: "you join this group", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
                self.dismissViewControllerAnimated(true, completion: {
                    
                    self.window.hidden = true
                    
                })
            }else{
                self.joinBtn.enabled = true
            }
            }, failure: {
                (operation,error) in
                print(error)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var statusBarH:CGFloat = 0
        var version = (UIDevice.currentDevice().systemVersion as NSString).doubleValue
        if(version >= 7.0)
        {
            statusBarH = 20
        }
        self.view.backgroundColor = UIColor.whiteColor()
        
        var _navigationBar:UINavigationBar = UINavigationBar()
        _navigationBar.frame = CGRectMake(0, 0+statusBarH, self.view.frame.size.width, 44)
        var _navigationItem:UINavigationItem = UINavigationItem()
        _navigationItem.title = "Join Group"
        _navigationBar.pushNavigationItem(_navigationItem, animated: false)
        var leftButton : UIBarButtonItem = UIBarButtonItem()
        leftButton.title = "back"
        leftButton.action = Selector("clickLeftButton")
        leftButton.target = self
        leftButton.style = UIBarButtonItemStyle.Bordered
        _navigationItem.setLeftBarButtonItem(leftButton, animated: false)
        self.view.addSubview(_navigationBar)
        
        _idField.frame = CGRectMake(15, 76+statusBarH, self.view.frame.size.width-30, 30+statusBarH/4)
        _idField.delegate = self
        _idField.placeholder = "Group ID"
        _idField.borderStyle = UITextBorderStyle.Bezel
        self.view.addSubview(_idField)
        
        _pwdField.frame = CGRectMake(15, 126+statusBarH, self.view.frame.size.width-30, 30+statusBarH/4)
        _pwdField.delegate = self
        _pwdField.placeholder = "Group password"
        _pwdField.borderStyle = UITextBorderStyle.Bezel
        self.view.addSubview(_pwdField)
        
        joinBtn.addTarget(self, action: Selector("join"), forControlEvents: UIControlEvents.TouchUpInside)
        joinBtn.frame = CGRectMake(15, 176+statusBarH, self.view.frame.size.width-30, 30+statusBarH/4)
        joinBtn.setTitle("Join", forState: UIControlState.Normal)
        joinBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        var image = UIImage(named: "smssdk.bundle/button4.png")
        joinBtn.setBackgroundImage(image, forState: UIControlState.Normal)
        self.view.addSubview(joinBtn)
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
