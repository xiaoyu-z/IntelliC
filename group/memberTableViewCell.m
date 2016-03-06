//
//  memberTableViewCell.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/23.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import "memberTableViewCell.h"

@implementation memberTableViewCell

@synthesize imageView;
@synthesize nameLabel;
@synthesize image;
@synthesize name;
@synthesize Desc;
@synthesize userId;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        imageView=[[UIImageView alloc] init];
        imageView.frame=CGRectMake(15, 5, 50, 50);
        [self.contentView addSubview:imageView];
        
        nameLabel=[[UILabel alloc] init];
        nameLabel.frame=CGRectMake(73, 15, 98, 22);
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [self.contentView addSubview:nameLabel];
        
        _nameDescLabel=[[UILabel alloc] init];
        _nameDescLabel.frame=CGRectMake(73, 40, 240, 15);
        _nameDescLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [self.contentView addSubview:_nameDescLabel];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setImage:(UIImage *)img
{
    if (![img isEqual:image])
    {
        image = [img copy];
        self.imageView.image = image;
    }
}

-(void)setName:(NSString *)n
{
    if (![n isEqualToString:name])
    {
        name = [n copy];
        self.nameLabel.text = name;
    }
}

-(void)setNameDesc:(NSString *)nDesc
{
    if (![nDesc isEqualToString:Desc])
    {
        Desc=[nDesc copy];
        self.nameDescLabel.text=Desc;
    }
}

@end
