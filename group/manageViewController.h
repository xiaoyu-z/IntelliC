//
//  manageViewController.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/23.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface manageViewController : UIViewController
@property(strong,nonatomic)NSString* groupId;
@property(strong,nonatomic)NSString* groupDesc;
@property(strong,nonatomic)NSString* groupName;
@property(strong,nonatomic)NSMutableArray* groupInfo;
@property(strong,nonatomic)NSMutableArray*Emailarray;
@end
