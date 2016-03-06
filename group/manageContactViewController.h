//
//  manageContactViewController.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/24.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface manageContactViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *table;
    UISearchBar *search;
    NSDictionary *allNames;
    NSMutableDictionary *names;
    NSMutableArray  *keys;
    BOOL    isSearching;
}

@property (nonatomic, strong)  UITableView *table;
@property (nonatomic, strong)  UIButton *manage;
@property (nonatomic, strong)  UISearchBar *search;
@property (nonatomic, strong) NSDictionary *allNames;
@property (nonatomic, strong) NSMutableDictionary *names;
@property (nonatomic, strong) NSMutableArray *keys;
@property(nonatomic,strong) NSString* myPhone;
@property (nonatomic,strong) UIWindow* window;
@property (nonatomic,strong) NSMutableArray* other;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@property(nonatomic,strong)NSString* groupId;
@property(nonatomic,strong)NSString* group_undate;
@property(nonatomic,strong)NSString* group_name;
@property(nonatomic,strong)NSString* group_pwd;
@property(nonatomic,strong)NSString* group_desc;
@property(nonatomic,strong)NSMutableArray *groupEmail;

@end
