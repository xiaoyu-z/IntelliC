//
//  servlet.m
//  HavFun
//
//  Created by 郑啸宇 on 15/5/10.
//  Copyright (c) 2015年 李俊良. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "servlet.h"
@interface servlet()


@end

@implementation servlet

-(instancetype) init
{
    self=[super init];
    if (self) {
        _manager=[AFHTTPRequestOperationManager manager];
       // _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
       // _manager.requestSerializer = [AFJSONRequestSerializer serializer];
       // _manager.responseSerializer = [AFJSONResponseSerializer serializer];
       //[_manager.requestSerializer setValue:@"text/xml; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
        //[_manager.requestSerializer setValue:@"POST"forHTTPHeaderField:@"Access-Control-Allow-Methods"];
    }
    
    return self;
}



@end
