//
//  groupViewController.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/22.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//
#import "CustomCell.h"
#import <UIKit/UIKit.h>

@interface groupViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate,
CustomCellDelegate,
UISearchBarDelegate>
{
    UITableView *table;
    UISearchBar *search;
    NSDictionary *allNames;
    NSMutableArray *names;
    BOOL    isSearching;
}

@property (nonatomic, strong)  UITableView *table;
@property (nonatomic, strong)  UISearchBar *search;
@property (nonatomic, strong) NSDictionary *allNames;
@property (nonatomic, strong) NSMutableArray *names;
@property(nonatomic,strong) NSString* myPhone;
@property (nonatomic,strong) UIWindow* window;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
