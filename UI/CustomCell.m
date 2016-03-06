//
//  CustomCell.m
//  Custom Cell
//
//  Created by Yang on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize imageView;
@synthesize nameLabel;
@synthesize image;
@synthesize name;
@synthesize nameDesc;
@synthesize updateTime;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _btn.frame=CGRectMake(self.frame.size.width -80, 15, 65, 30);
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
    if (![nDesc isEqualToString:nameDesc])
    {
        nameDesc=[nDesc copy];
        self.nameDescLabel.text=nameDesc;
    }
}

@end
