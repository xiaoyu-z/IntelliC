//
//  inviteContactsViewController.h
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/23.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <SMS_SDK/SMS_SDKResultHanderDef.h>

@interface inviteContactsViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate,ABNewPersonViewControllerDelegate>
{
    UITableView *table;
    UISearchBar *search;
    NSDictionary *allNames;
    NSMutableDictionary *names;
    NSMutableArray  *keys;
    BOOL    isSearching;
}

@property (nonatomic, strong)  UITableView *table;
@property (nonatomic, strong)  UISearchBar *search;
@property (nonatomic, strong) NSDictionary *allNames;
@property (nonatomic, strong) NSMutableDictionary *names;
@property (nonatomic, strong) NSMutableArray *keys;
@property(nonatomic,strong) NSString* myPhone;
@property (nonatomic,strong) UIWindow* window;
@property (nonatomic,strong) NSString* groupname;
@property (nonatomic,strong) NSString* groupid;
@property (nonatomic,strong) NSString* grouppwd;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void)setMyData:(NSMutableArray*) array;
@end

