//
//  OwnerDAO.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/13.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import "OwnerDAO.h"

@implementation OwnerDAO
static OwnerDAO *sharedManager = nil;

+ (OwnerDAO*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager managedObjectContext];
        
    });
    return sharedManager;
}


//插入Note方法
-(int) create:(Owner*)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Owner" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"email =  %@", model.email];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        OwnerObj *verifyowner = [listData lastObject];
        if(![verifyowner.email isEqualToString: model.email]){
    OwnerObj *owner = [NSEntityDescription insertNewObjectForEntityForName:@"Owner" inManagedObjectContext:cxt];
    [owner setValue: model.phone forKey:@"phone"];
    [owner setValue: model.email forKey:@"email"];
    [owner setValue:model.defaultPhone forKey:@"defaultPhone"];
    [owner setValue:model.defaultEmail forKey:@"defaultEmail"];
    [owner setValue:model.name forKey:@"name"];
    owner.phone = model.phone;
    owner.email = model.email;
    owner.defaultEmail = model.defaultEmail;
    owner.defaultPhone = model.defaultPhone;
            owner.name =model.name;
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
        NSLog(@"插入数据成功");
    } else {
        NSLog(@"插入数据失败");
        return -1;
        }
        
    }
    }else if([listData count] == 0){
        OwnerObj *owner = [NSEntityDescription insertNewObjectForEntityForName:@"Owner" inManagedObjectContext:cxt];
        [owner setValue: model.phone forKey:@"phone"];
        [owner setValue: model.email forKey:@"email"];
        [owner setValue:model.defaultPhone forKey:@"defaultPhone"];
        [owner setValue:model.defaultEmail forKey:@"defaultEmail"];
        [owner setValue:model.name forKey:@"name"];
        owner.phone = model.phone;
        owner.email = model.email;
        owner.defaultEmail = model.defaultEmail;
        owner.defaultPhone = model.defaultPhone;
        owner.name = model.name;
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]){
            NSLog(@"插入数据成功");
        } else {
            NSLog(@"插入数据失败");
            return -1;
        }

    }
    
    return 0;
}

//删除Note方法
-(int) remove:(Owner*)model
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Owner" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"email =  %@", model.email];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        OwnerObj *owner = [listData lastObject];
        [self.managedObjectContext deleteObject:owner];
        
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]){
            NSLog(@"删除数据成功");
        } else {
            NSLog(@"删除数据失败");
            return -1;
        }
    }
    
    return 0;
}
-(void)deleteAll{
    OwnerDAO* op = [OwnerDAO sharedManager];
    NSMutableArray* ownerArray = [op findAll];
    for(Owner* owner in ownerArray){
        [op remove:owner];
    }
}

//修改Note方法
-(int) modify:(Owner*)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Owner" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"email =  %@", model.email];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        OwnerObj *owner = [listData lastObject];
        owner.phone = model.phone;
        owner.email = model.email;
        owner.name = model.name;
        owner.defaultEmail = model.defaultEmail;
        owner.defaultPhone = model.defaultPhone;
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]){
            NSLog(@"修改数据成功");
        } else {
            NSLog(@"修改数据失败");
            return -1;
        }
    }
    return 0;
}

//查询所有数据方法
-(NSMutableArray*) findAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Owner" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"email" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (OwnerObj *mo in listData) {
        Owner *note = [[Owner alloc] init];
        note.email = mo.email;
        note.phone = mo.phone;
        note.defaultPhone = mo.defaultPhone;
        note.defaultEmail = mo.defaultEmail;
        note.name = mo.name;
        [resListData addObject:note];
    }
    
    return resListData;
}

//按照主键查询数据方法
-(Owner*) findById:(NSString*)myemail
{
//    NSManagedObjectContext *cxt = [self managedObjectContext];
//    
//    NSEntityDescription *entityDescription = [NSEntityDescription
//                                              entityForName:@"Owner" inManagedObjectContext:cxt];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDescription];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                              @"email =  %@",myemail];
//    [request setPredicate:predicate];
//    NSError *error = nil;
//    NSArray *listData = [cxt executeFetchRequest:request error:&error];
//    if ([listData count] > 0) {
//        OwnerObj *mo = [listData lastObject];
//        Owner *owner = [[Owner alloc] init];
//        owner.email = mo.email;
//        owner.phone = mo.phone;
//        return owner;
//    }
    return nil;
}
@end
