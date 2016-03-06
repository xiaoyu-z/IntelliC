//
//  OwnerObj.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/22.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GroupObj;

@interface OwnerObj : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * defaultEmail;
@property (nonatomic, retain) NSString * defaultPhone;
@property (nonatomic, retain) GroupObj *has;

@end
