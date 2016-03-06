//
//  groupContactViewController.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/23.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <SMS_SDK/SMS_SDKResultHanderDef.h>
@interface groupContactViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
-(void)setName:(NSString*)name;
-(void)setPhone:(NSString *)phone AndPhone2:(NSString*)phone2;
-(void)setContactID:(NSString*)email;
@property(strong,nonatomic)NSString*groupId;
@property BOOL isManager;
@end
