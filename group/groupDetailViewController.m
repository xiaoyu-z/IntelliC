//
//  groupDetailViewController.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/23.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import "groupDetailViewController.h"
#import "servlet.h"
#import "OwnerDAO.h"
#import "NSDictionary-DeepMutableCopy.h"
#import "memberTableViewCell.h"
#import "inviteContactsViewController.h"
#import "groupViewController.h"
#import "modifyViewController.h"
#import "groupContactViewController.h"
#import "manageViewController.h"
@interface groupDetailViewController ()
    {
        NSMutableArray* groupData;
        NSMutableArray* _addressBookData;
        NSMutableArray* _friendsData;
        NSMutableArray* _other;
        NSMutableArray* groupId;
        int num;
        CGFloat statusBarHeight;
    }
    
    @end
@implementation groupDetailViewController
@synthesize names;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allNames;
@synthesize manage;
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

//-(void)clickLeftButton
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        _window.hidden=YES;
//    }];
//
//    //修改消息条数为0
//    [SMS_SDK setLatelyFriendsCount:0];
//
//    if (_friendsBlock) {
//        _friendsBlock(1,0);
//    }
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _friendsData=[NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _other=[NSMutableArray array];
    groupId = [NSMutableArray array];
    num = -1;
    self.view.backgroundColor=[UIColor whiteColor];
    
    statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
    statusBarHeight=20;
    }
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0+statusBarHeight, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil)style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Invite", nil)style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickRightButton)];

    [navigationItem setTitle:self.group_name];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setRightBarButtonItem:rightButton];
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
    search.delegate=self;
    
    manage = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-45, self.view.frame.size.width, 45)];
    [manage setTitle:@"Manage" forState:UIControlStateNormal];
    [manage addTarget:self action:@selector(manageG) forControlEvents:UIControlEventTouchUpInside];
    manage.hidden = YES;
    NSString *icon = [NSString stringWithFormat:@"smssdk.bundle/button4.png"];
    [manage setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [manage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:manage];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _other = [NSMutableArray array];
    servlet* detail = [[servlet alloc]init];
    OwnerDAO* op = [OwnerDAO sharedManager];
    Owner* owner = [[op findAll]objectAtIndex:0];
    [detail.manager POST:@"http://192.168.1.108:8001/api/update_group/" parameters:@{@"user_email":owner.email,@"group_id":self.groupId,@"update_time":@"0"}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        groupData = [(NSDictionary* )responseObject objectForKey:@"data"];
        NSString* masterEmail = [(NSDictionary* )responseObject objectForKey:@"group_master"];
        if([masterEmail isEqualToString:owner.email]){
            manage.hidden = NO;
            table.frame = CGRectMake(0, 88+statusBarHeight, self.view.frame.size.width, self.view.bounds.size.height-(128+statusBarHeight));
        }
        //NSLog(@"%lu",(unsigned long)groupData.count);
        for (int i=0; i<groupData.count; i++) {
            NSDictionary* groupMember = [groupData objectAtIndex:i];
            NSString* groupIdEmail= [groupMember objectForKey:@"user_email"];
            if([groupIdEmail isEqualToString:owner.email])
                num = i;
            NSString* str = [NSString stringWithFormat:@"%@!%@=%@",[groupMember objectForKey:@"name"],[groupMember objectForKey:@"phone"],[groupMember objectForKey:@"email"]];
            //NSLog(@"%@",str);
            [_other addObject:str];
            [groupId addObject:groupIdEmail];
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (_other != nil) {
            [dict setObject:_other forKey:@"Group Member"];
            self.allNames = dict;
            [self resetSearch];
            [table reloadData];
        }
        
        
        //NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];

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
    
    static NSString *CellWithIdentifier = @"memberCellIdentifier";
    memberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell=[[memberTableViewCell alloc] init];
    }
    
    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    
    NSRange range=[str1 rangeOfString:@"!"];
    NSString* str2=[str1 substringFromIndex:range.location];
    NSRange range2 =[str2 rangeOfString:@"="];
    NSString* str3=[str2 substringToIndex:range2.location];
    NSString* phone=[str3 stringByReplacingOccurrencesOfString:@"!" withString:@""];
    //NSString *cellPhone = [phone substringToIndex:[phone length] ];
    NSString* name=[str1 substringToIndex:range.location];
    NSString* email=[[str2 substringFromIndex:range2.location] stringByReplacingOccurrencesOfString:@"=" withString:@""];
    [cell setDesc:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"phonecontacts", nil),phone]];
    //cell.Desc=[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"phonecontacts", nil),phone];
    cell.email = email;
    //cell.recordid = recordid;
    cell.name=name;
    cell.index = (int)indexPath.row;
    cell.section = (int)[indexPath section];
    cell.userId = [groupId objectAtIndex:indexPath.row];
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
    memberTableViewCell* cell =(memberTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.index == num){
        modifyViewController* modify= [[modifyViewController alloc]init];
        modify.name = cell.name;
        modify.email = cell.email;
        modify.groupId = self.groupId;
        NSString* str = [cell.Desc substringFromIndex:[cell.Desc rangeOfString:@":"].location+1];
        modify.phone = str;
        [self presentViewController:modify animated:YES completion:nil];
    }
    else{
        groupContactViewController* contant = [[groupContactViewController alloc]init];
        [contant setName: cell.name];
        NSString* str = [cell.Desc substringFromIndex:[cell.Desc rangeOfString:@":"].location+1];
        [contant setPhone:str AndPhone2:nil];
        [contant setContactID:[groupId objectAtIndex:indexPath.row]];
        contant.groupId = self.groupId;
        if(manage.hidden){
            contant.isManager = NO;
        }
        else
        {
            contant.isManager = YES;
        }
        [self presentViewController:contant animated:YES completion:nil];
    }
//
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


-(void)clickLeftButton{
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *groupView=[secondStroyBoard instantiateViewControllerWithIdentifier:@"group"];
    groupView.selectedIndex = 1;
    [self presentModalViewController:groupView animated:YES];
}
-(void)clickRightButton{
    inviteContactsViewController* invite = [[inviteContactsViewController alloc]init];
    invite.groupid = self.groupId;
    invite.groupname = self.group_name;
    invite.grouppwd = self.group_pwd;
    [self presentViewController:invite animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)manageG{
    manageViewController * manager = [[manageViewController alloc]init];
    manager.groupInfo =_other;
    manager.groupDesc = self.group_desc;
    manager.groupId =self.groupId;
    manager.groupName = self.group_name;
    manager.Emailarray = groupId;
    [self presentViewController:manager animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
