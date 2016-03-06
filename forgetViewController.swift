//
//  forgetViewController.swift
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/18.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

import UIKit

class forgetViewController: UIViewController,UITextFieldDelegate{
    var window:UIWindow = UIWindow()
    
    func clickLeftButton(){
        self.dismissViewControllerAnimated(true, completion: {
        
            self.window.hidden = true
        
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
        _navigationItem.title = "Reset"
        _navigationBar.pushNavigationItem(_navigationItem, animated: false)
        var leftButton : UIBarButtonItem = UIBarButtonItem()
        leftButton.title = "back"
        leftButton.action = Selector("clickLeftButton")
        leftButton.target = self
        leftButton.style = UIBarButtonItemStyle.Bordered
        _navigationItem.setLeftBarButtonItem(leftButton, animated: false)
        self.view.addSubview(_navigationBar)
        
        var _mailField:UITextField = UITextField()
        _mailField.frame = CGRectMake(15, 76+statusBarH, self.view.frame.size.width-30, 30+statusBarH/4)
        _mailField.delegate = self
        _mailField.placeholder = "Your E-mail"
        _mailField.borderStyle = UITextBorderStyle.Bezel
        self.view.addSubview(_mailField)
        
        var _verifyField:UITextField = UITextField()
        _verifyField.frame = CGRectMake(15, 126+statusBarH,(self.view.frame.size.width-30)/3*2, 30+statusBarH/4)
        _verifyField.delegate = self
        _verifyField.placeholder="Verify Code"
        _verifyField.borderStyle = UITextBorderStyle.Bezel
        self.view.addSubview(_verifyField)
        
        var _codebutton:UIButton = UIButton()
        _codebutton.setTitle("get code", forState: UIControlState.Normal)
        _codebutton.addTarget(self, action:Selector("getcode"), forControlEvents:UIControlEvents.TouchUpInside)
        _codebutton.frame = CGRectMake(25+(self.view.frame.size.width-30)/3*2, 126+statusBarH, (self.view.frame.size.width-30)/3-10, 30+statusBarH/4)
        _codebutton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        var image = UIImage(named: "smssdk.bundle/button4.png")
        _codebutton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        _codebutton.setBackgroundImage(image, forState: UIControlState.Normal)
        self.view.addSubview(_codebutton)
        
        var _pwdField:UITextField = UITextField()
        _pwdField.frame = CGRectMake(15, 176+statusBarH*5/4, self.view.frame.size.width-30, 30+statusBarH/4)
        _pwdField.delegate = self
        _pwdField.placeholder = "New Password"
        _pwdField.borderStyle = UITextBorderStyle.Bezel
        _pwdField.secureTextEntry = true
        self.view.addSubview(_pwdField)
        
        var _submitbutton:UIButton = UIButton()
        _submitbutton.setTitle("submit", forState: UIControlState.Normal)
        _submitbutton.addTarget(self, action:Selector("submit"), forControlEvents:UIControlEvents.TouchUpInside)
        _submitbutton.frame = CGRectMake(15, 216+statusBarH*3/2, self.view.frame.size.width-30, 30+statusBarH/4)
        _submitbutton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //var image = UIImage(named: "smssdk.bundle/button4.png")
        _submitbutton.setBackgroundImage(image, forState: UIControlState.Normal)
        _submitbutton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.view.addSubview(_submitbutton)

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getcode(){
    
        var verifyCode: servlet = servlet()
    
    }
    func submit(){
    
    
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
