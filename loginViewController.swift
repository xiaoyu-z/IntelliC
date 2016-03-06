//
//  loginViewController.swift
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/18.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

import UIKit

class loginViewController: UIViewController,UITextFieldDelegate {
    var _mailField:UITextField = UITextField()
    var _pwdField:UITextField = UITextField()
    func regClicked(){
        var regView:RegViewController = RegViewController()
        self.presentViewController(regView, animated: true, completion:{})
    }
    func forgetClicked(){
        var forget:forgetViewController = forgetViewController()
        self.presentViewController(forget, animated: true, completion: {})
    
    }
    func login(){
        SMS_MBProgressHUD.showMessag("Login", toView: self.view)
        var login : servlet = servlet()
        //check
        
        login.manager.POST("http://192.168.1.108:8001/api/can_log_in/", parameters:["user_email":self._mailField.text,"pwd":self._pwdField.text], success: {(operation,responseObject) in
        print(responseObject)
            if((responseObject as! NSDictionary).objectForKey("message") as! String == "can"){
                var userDefalt :NSUserDefaults = NSUserDefaults()
                var op: OwnerDAO = OwnerDAO()
                op.deleteAll()
                var owner:Owner = Owner()
                owner.phone = (((responseObject as! NSDictionary).objectForKey("data")) as! NSDictionary).objectForKey("user_phone") as! String
                owner.email = self._mailField.text
                owner.defaultEmail = owner.email
                owner.defaultPhone = owner.phone
                op.create(owner)
                
                
                var story : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                self.view.window?.rootViewController?.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
                self.view.window?.rootViewController = story.instantiateInitialViewController() as? UIViewController
                userDefalt.setBool(false, forKey: "FirstTimeLoad")

            }
            else{
            var alter = UIAlertView(title: "Failure", message: "the email or password is not corect", delegate: self, cancelButtonTitle: "OK")
                alter.show()
                }
            }, failure: {
        (operation,error) in
                print(error)
        })
        //self._mailField
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        _navigationItem.title = "login"
        var regBtn = UIBarButtonItem(title: "Register", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("regClicked"))
        var forgetBtn = UIBarButtonItem(title: "Forget", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("forgetClicked"))
        _navigationItem.setLeftBarButtonItem(forgetBtn, animated: false)
        _navigationItem.setRightBarButtonItem(regBtn, animated: false)
        _navigationBar.pushNavigationItem(_navigationItem, animated: false)
        self.view.addSubview(_navigationBar)
        
        
        
        _mailField.frame = CGRectMake(15, 76+statusBarH, self.view.frame.size.width-35, 35+statusBarH/4)
        _mailField.delegate = self
        _mailField.placeholder = "Your E-mail"
        _mailField.borderStyle = UITextBorderStyle.Bezel
        self.view.addSubview(_mailField)
        
        
        _pwdField.frame = CGRectMake(15, 135+statusBarH*5/4, self.view.frame.size.width-30, 35+statusBarH/4)
        _pwdField.delegate = self
        _pwdField.placeholder = "Your Password"
        _pwdField.borderStyle = UITextBorderStyle.Bezel
        _pwdField.secureTextEntry = true
        self.view.addSubview(_pwdField)
        
        var loginBtn:UIButton = UIButton()
        loginBtn.frame = CGRectMake(15, 194+statusBarH*3/2, self.view.frame.size.width-30, 35)
        loginBtn.setTitle("Login", forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.addTarget(self, action: Selector("login"), forControlEvents: UIControlEvents.TouchUpInside)
        var image = UIImage(named: "smssdk.bundle/button4.png")
        loginBtn.setBackgroundImage(image, forState: UIControlState.Normal)
        self.view.addSubview(loginBtn)
        
        
        

        

        // Do any additional setup after loading the view.
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
