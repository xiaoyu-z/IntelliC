//
//  createViewController.swift
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/22.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

import UIKit

class createViewController: UIViewController ,UITextFieldDelegate{
    var window:UIWindow = UIWindow()
    var _nameField:UITextField = UITextField()
    var _descField:UITextField = UITextField()
    var createBtn:UIButton = UIButton()
    func clickLeftButton(){
        self.dismissViewControllerAnimated(true, completion: {
            
            self.window.hidden = true
            
        })
        
    }
    func create(){
        createBtn.enabled = false
        if(self._nameField.text==nil||self._nameField.text=="")
        {return}
        var groupid = NSNumber()
        var op:OwnerDAO = OwnerDAO()
        var create:servlet = servlet()
        var email = op.findAll()[0].email
        create.manager.POST("http://192.168.1.108:8001/api/create_group/", parameters: ["user_email":email,"group_name":self._nameField.text],  success: {(operation,responseObject) in
            print(responseObject)
            if((responseObject as! NSDictionary).objectForKey("message") as! String == "create new group"){
                var data = (responseObject as! NSDictionary).objectForKey("data") as! NSDictionary
                groupid =  data.objectForKey("group_id") as! NSNumber
                var group_pwd  = data.objectForKey("group_pwd") as! NSString
                
                //缓存
                var alert:UIAlertView = UIAlertView(title: "Success", message: "your group id is \(groupid),\n your group verify code is \(group_pwd)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                var insertTitle = servlet()
                insertTitle.manager.POST("http://192.168.1.108:8001/api/insert_title/", parameters: ["user_email":email,"group_id":"\(groupid)","new_title":self._descField.text], success: {(operation,responseObject) in
                    print(responseObject)
                    self.dismissViewControllerAnimated(true, completion: {
                        self.window.hidden = true
                    })
                    }, failure: {nil}())

            }else{
                self.createBtn.enabled = true
            
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
        _navigationItem.title = "Create Group"
        _navigationBar.pushNavigationItem(_navigationItem, animated: false)
        var leftButton : UIBarButtonItem = UIBarButtonItem()
        leftButton.title = "back"
        leftButton.action = Selector("clickLeftButton")
        leftButton.target = self
        leftButton.style = UIBarButtonItemStyle.Bordered
        _navigationItem.setLeftBarButtonItem(leftButton, animated: false)
        self.view.addSubview(_navigationBar)
        
        _nameField.frame = CGRectMake(15, 76+statusBarH, self.view.frame.size.width-30, 30+statusBarH/4)
        _nameField.delegate = self
        _nameField.placeholder = "Group Name"
        _nameField.borderStyle = UITextBorderStyle.Bezel
        self.view.addSubview(_nameField)
        
        _descField.frame = CGRectMake(15, 126+statusBarH, self.view.frame.size.width-30, 30+statusBarH/4)
        _descField.delegate = self
        _descField.placeholder = "Group Desctription"
        _descField.borderStyle = UITextBorderStyle.Bezel
        self.view.addSubview(_descField)
        
        createBtn.addTarget(self, action: Selector("create"), forControlEvents: UIControlEvents.TouchUpInside)
        createBtn.frame = CGRectMake(15, 176+statusBarH, self.view.frame.size.width-30, 30+statusBarH/4)
        createBtn.setTitle("Create", forState: UIControlState.Normal)
        createBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        var image = UIImage(named: "smssdk.bundle/button4.png")
        createBtn.setBackgroundImage(image, forState: UIControlState.Normal)
        self.view.addSubview(createBtn)
        
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
