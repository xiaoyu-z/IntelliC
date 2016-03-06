//
//  IngroupObj.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/21.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IngroupObj : NSManagedObject

@property (nonatomic, retain) NSString * user_email;
@property (nonatomic, retain) NSString * groupId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * openEmail;

@end
