//
//  RecordObj.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/21.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RecordObj : NSManagedObject

@property (nonatomic, retain) NSString * contactPhone;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * type;

@end
