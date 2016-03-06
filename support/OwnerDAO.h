//
//  OwnerDAO.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/13.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import "CoreDataDAO.h"
#import <CoreData/CoreData.h>
#import "Owner.h"
#import "OwnerObj.h"
@interface OwnerDAO : CoreDataDAO
+(OwnerDAO*)sharedManager;

-(int) create:(Owner*)model;
//
////删除Note方法
-(int) remove:(Owner*)model;
//
////修改Note方法
-(int) modify:(Owner*)model;
//
////查询所有数据方法
-(NSMutableArray*) findAll;
//
////按照主键查询数据方法
-(Owner*) findById:(NSString*)myemail;

-(void)deleteAll;
//
@end
