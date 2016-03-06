//
//  inviteContactsViewController.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/23.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//
#import "SectionsViewControllerFriends.h"
#import "NSDictionary-DeepMutableCopy.h"
#import "CustomCell.h"
#import "InvitationViewControllerEx.h"
#import "VerifyViewController.h"
#import "SMS_HYZBadgeView.h"
#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/SMS_AddressBook.h>
#import "SMS_MBProgressHUD+Add.h"
#import <AddressBook/AddressBook.h>
#import "inviteContactsViewController.h"

@interface inviteContactsViewController ()
{
    NSMutableArray* _addressBookData;
    NSMutableArray* _friendsData;
    NSMutableArray* _other;
    int num;
}
@end

@implementation inviteContactsViewController

@synthesize names;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allNames;

#pragma mark -
#pragma mark Custom Methods
static UIAlertView* _alert1 = nil;
- (void)CustomCellBtnClick:(CustomCell *)cell{
    
    
}
- (void)resetSearch
{
    NSMutableDictionary *allNamesCopy = [self.allNames mutableDeepCopy];
    self.names = allNamesCopy;
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    
    [keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:[[self.allNames allKeys]
                                   sortedArrayUsingSelector:@selector(compare:)]];
    self.keys = keyArray;
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    
    for (NSString *key in self.keys)
    {
        NSMutableArray *array = [names valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSString *name in array)
        {
            if ([name rangeOfString:searchTerm
                            options:NSCaseInsensitiveSearch].location == NSNotFound)
                [toRemove addObject:name];
        }
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove];
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
}
-(void)clickLeftButton{
    [self dismissViewControllerAnimated:YES completion:^{
        _window.hidden = YES;
    }];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _friendsData=[NSMutableArray array];
    }
    return self;
}

-(void)setMyData:(NSArray*) array
{
    _friendsData=[NSMutableArray arrayWithArray:array];
}

-(void)clickAdd{
    ABNewPersonViewController *viewController = [[ABNewPersonViewController alloc] init];
    viewController.newPersonViewDelegate = self;
    UINavigationController *newNavigationController = [[UINavigationController alloc]
                                                       initWithRootViewController:viewController];
    [self presentViewController:newNavigationController animated:YES completion:nil];}
#pragma mark -
#pragma mark ABNewPersonViewController 委托方法实现
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView
       didCompleteWithNewPerson:(ABRecordRef)person
{
    
    _addressBookData=[SMS_SDK addressBook];
    NSMutableArray* _oth = [NSMutableArray array];
    for (int i=0; i<_addressBookData.count; i++) {
        SMS_AddressBook* person1=[_addressBookData objectAtIndex:i];
        if(person1.phones!=nil&& ![person1.phones isEqualToString: @""]&&person1.name!=nil&&[person1.phones rangeOfString:@"-"].location==NSNotFound)
        {
            if([person1.phones rangeOfString:@"+"].location != NSNotFound)
            {
                person1.phones=[person1.phones stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            NSString* str1=[NSString stringWithFormat:@"%@+%@!%@",person1.name,person1.phones,person1.recordid];
            [_oth addObject:str1];
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:_oth forKey:NSLocalizedString(@"toinvitefriends", nil)];
    
    self.allNames = dict;
    
    [self resetSearch];
    
    [table reloadData];
    [newPersonView dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //获取支持的地区列表
    [SMS_MBProgressHUD showMessag:NSLocalizedString(@"loading", nil) toView:self.view];
    [SMS_SDK getAppContactFriends:1
                           result:^(enum SMS_ResponseState state, NSArray *array)
     {
         if (1==state)
         {
             [self setMyData:[NSMutableArray arrayWithArray:array]];
         }
     }];
    
    //判断用户通讯录是否授权
    if (_alert1)
    {
        [_alert1 show];
    }
    
    if(ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized && _alert1==nil)
    {
        NSString* str=[NSString stringWithFormat:NSLocalizedString(@"authorizedcontact", nil)];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                      message:str
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                            otherButtonTitles:nil, nil];
        _alert1 = alert;
        [alert show];
    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0+statusBarHeight, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil)style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton animated:NO];
    [navigationItem setTitle:@"Invite"];
    [self.view addSubview:navigationBar];
    //添加搜索框
    search=[[UISearchBar alloc] init];
    search.frame=CGRectMake(0, 44+statusBarHeight, self.view.frame.size.width, 44);
    [self.view addSubview:search];
    
    
    //添加table
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 88+statusBarHeight, self.view.frame.size.width, self.view.bounds.size.height-(88+statusBarHeight)) style:UITableViewStylePlain];
    table.dataSource=self;
    table.delegate=self;
    [self.view addSubview:table];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    search.delegate=self;
    
}

#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [keys count];
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return 0;
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    return [nameSection count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];
    
    NSArray *nameSection = [names objectForKey:key];
    
    static NSString *CellWithIdentifier = @"CustomCellIdentifier";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell=[[CustomCell alloc] init];
        cell.delegate = self;
    }
    
    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    
    NSRange range=[str1 rangeOfString:@"+"];
    NSString* str2=[str1 substringFromIndex:range.location];
    NSRange range2 =[str2 rangeOfString:@"!"];
    NSString* str3=[str2 substringToIndex:range2.location];
    NSString* phone=[str3 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    //NSString *cellPhone = [phone substringToIndex:[phone length] ];
    NSString* name=[str1 substringToIndex:range.location];
    NSString* recordid=[[str2 substringFromIndex:range2.location] stringByReplacingOccurrencesOfString:@"!" withString:@""];
    cell.nameDesc=[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"phonecontacts", nil),phone];
    
    //cell.recordid = recordid;
    cell.name=name;
    cell.index = (int)indexPath.row;
    cell.section = (int)[indexPath section];
    
    int myindex=(int)(cell.index)%20+1;
    NSString* imagePath=[NSString stringWithFormat:@"%d.png",myindex];
    cell.image=[UIImage imageNamed:imagePath];
    
    return cell;
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return nil;
    
    NSString *key = [keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
        return nil;
    
    return key;
}

#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
    search.text = @"";
    isSearching = NO;
    [tableView reloadData];
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    NSString *key = [keys objectAtIndex:index];
    if (key == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:YES];
    CustomCell* cell =(CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSString* str = [cell.nameDesc substringFromIndex:[cell.nameDesc rangeOfString:@":"].location+1];
    [SMS_SDK sendSMS:str AndMessage:[NSString stringWithFormat:@"dear %@, I'd like to invite you to join this group \"%@\",the group id is \"%@\" and the group password is \"%@\" By IntelliC－http://gumption.chinacloudapp.cn/download/IntelliC.apk",cell.name,self.groupname,self.groupid,self.grouppwd]];
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    [table reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchTerm
{
    if ([searchTerm length] == 0)
    {
        [self resetSearch];
        [table reloadData];
        return;
    }
    
    [self handleSearchForTerm:searchTerm];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
    search.text = @"";
    
    [self resetSearch];
    [table reloadData];
    
    [searchBar resignFirstResponder];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    //isSearching = NO;
    [search resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _other=[NSMutableArray array];
    _addressBookData=[SMS_SDK addressBook];
    NSLog(@"获取到了%zi条通讯录信息",_addressBookData.count);
    
    //NSLog(@"获取到了%zi条好友信息",_friendsData.count);
    
    
    //双层循环 取出重复的通讯录信息
    for (int i=0; i<_addressBookData.count; i++) {
        SMS_AddressBook* person1=[_addressBookData objectAtIndex:i];
        if(person1.phones!=nil&& ![person1.phones isEqualToString: @""]&&person1.name!=nil&&[person1.phones rangeOfString:@"-"].location==NSNotFound)
        {
            if([person1.phones rangeOfString:@"+"].location != NSNotFound)
            {
                person1.phones=[person1.phones stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            NSString* str1=[NSString stringWithFormat:@"%@+%@!%@",person1.name,person1.phones,person1.recordid];
            [_other addObject:str1];
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_other forKey:NSLocalizedString(@"toinvitefriends", nil)];
    self.allNames = dict;
    [self resetSearch];
    [table reloadData];
}
@end


