//
//  meViewController.swift
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/14.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

import UIKit

class meViewController: UIViewController {
    var groupIdArray = NSMutableArray()
    @IBOutlet weak var uploadBtn: UIButton!

    @IBOutlet weak var download: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var changePwd: UIButton!
    @IBOutlet weak var defaultInfo: UIButton!
    @IBAction func uploadClicked(sender: AnyObject) {
        var owner = OwnerDAO().findAll()[0] as! Owner
        var addressBook = SMS_SDK.addressBook()
        var contactArray = NSMutableArray(capacity: 1)
        for var i = 0;i<addressBook.count;++i{
        var contact = NSMutableDictionary(capacity: 1)
        var person: SMS_AddressBook = addressBook.objectAtIndex(i) as! SMS_AddressBook
            if person.phones != nil && person.name != nil  {
                contact.setValue(person.phones, forKey: "phone")
                contact.setValue(person.name, forKey: "name")
                contactArray.addObject(contact)
            }
        }
        
        var jsondata = NSJSONSerialization.dataWithJSONObject(contactArray, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        var jsonString = NSString(data: jsondata!, encoding: NSUTF8StringEncoding)
        var upload = servlet()
        upload.manager.POST("http://192.168.1.108:8001/api/set_phone_book/", parameters:["user_email":owner.email,"data":jsondata!], success: {(operation,responseObject) in
            print(responseObject)
            var alert  = UIAlertView(title: "Success", message: "Upload Success", delegate: self, cancelButtonTitle: "cancle")
            alert.show()

            }, failure: {
                (operation,error) in
                print(error)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.selectedImage = UIImage(named: "tab3.png");
        var getall : servlet = servlet()
        //check
        var op = OwnerDAO()
        var owner :Owner = op.findAll()[0] as! Owner
        getall.manager.POST("http://192.168.1.108:8001/api/get_all_group_message/", parameters:["user_email":owner.email], success: {(operation,responseObject) in
            print(responseObject)
            
            
            var groupInfoarray = ((responseObject as! NSMutableDictionary).objectForKey("data"))as! NSArray?
            if(!groupInfoarray!.isEqual(nil))
            {
                for var i=0;i<groupInfoarray!.count;++i
                {
                self.groupIdArray.addObject(groupInfoarray!.objectAtIndex(i).objectForKey("group_id")!)
                    }
            
                }
            }
            , failure: {
                (operation,error) in
                print(error)
        })

        // Do any additional setup after loading the view.
    }


    

    @IBAction func defalutMessageClicked(sender: AnyObject) {
        var myDefault = mydefalutInfoViewController()
        if(!self.groupIdArray.isEqual(nil)){
        myDefault.groupId = self.groupIdArray
        self.presentViewController(myDefault, animated: true, completion: nil)
        }
        else{
        var alter = UIAlertView(title: "Error", message: "no group", delegate: self, cancelButtonTitle: "OK")
        alter.show()
        }
    }
    
    @IBAction func changePwd(sender: AnyObject) {
        var change = changePwdViewController()
        self.presentViewController(change, animated: true, completion: nil)
        
    }

    @IBAction func logoutClicked(sender: AnyObject) {
        var userDefult:NSUserDefaults = NSUserDefaults()
        userDefult.setBool(true, forKey: "FirstTimeLoad");
        var login = loginViewController()
        self.view.window?.rootViewController = login
    }
    

    @IBAction func downClicked(sender: AnyObject) {
        var upload = servlet()
        var op = OwnerDAO()
        var alert  = UIAlertView(title: "Failure", message: "The latest back-up has be applied", delegate: self, cancelButtonTitle: "cancle")
        alert.show()
        return
        
        var owner :Owner = op.findAll()[0] as! Owner
        upload.manager.POST("http://192.168.1.108:8001/api/get_phone_book/", parameters:["user_email":owner.email], success: {(operation,responseObject) in
            print(responseObject)
            var jsondata = ((responseObject as! NSDictionary).objectForKey("data")) as! NSData
            }, failure: {
                (operation,error) in
                print(error)
        })
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
