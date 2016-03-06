//
//  GroupObj.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/22.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IngroupObj;

@interface GroupObj : NSManagedObject

@property (nonatomic, retain) NSString * gownerId;
@property (nonatomic, retain) NSString * groupId;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * numOfMember;
@property (nonatomic, retain) NSString * timeStamp;
@property (nonatomic, retain) NSString * vignette;
@property (nonatomic, retain) NSString * groupPwd;
@property (nonatomic, retain) IngroupObj *include;

@end
