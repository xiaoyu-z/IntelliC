//
//  memberTableViewCell.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/23.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface memberTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *nameDescLabel;
@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (copy,nonatomic) NSString* Desc;
@property (copy,nonatomic) NSString* email;
@property (nonatomic, assign) int index;
@property (nonatomic,assign) int section;
@property (copy,nonatomic) NSString *userId;
@end


