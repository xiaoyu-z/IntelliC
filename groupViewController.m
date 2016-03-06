//
//  groupViewController.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/22.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//
#import "Group.h"
#import "groupViewController.h"
#import "NSDictionary-DeepMutableCopy.h"
#import "CustomCell.h"
#import "InvitationViewControllerEx.h"
#import "VerifyViewController.h"
#import "Intellic-Swift.h"
#import "servlet.h"
#import "OwnerDAO.h"
#import "initGroupViewController.h"
#import "groupDetailViewController.h"
#import "SMS_MBProgressHUD.h"
@interface groupViewController (){
    NSMutableArray* groupInfo;
    NSMutableArray* _addressBookData;
    NSMutableArray* _friendsData;
    //NSMutableArray* _other;
    //int num;
}

@end

@implementation groupViewController


@synthesize names;
@synthesize table;
@synthesize search;
@synthesize allNames;


#pragma mark -
#pragma mark Custom Methods
static UIAlertView* _alert1 = nil;
- (void)CustomCellBtnClick:(CustomCell *)cell{
    return;
}

-(void)clickAdd{
    createViewController* createView = [[createViewController alloc]init];
    [self presentViewController:createView animated:YES completion:nil];
}
-(void)clickFind{
    joinViewController* joinView =[[joinViewController alloc]init];
    [self presentViewController:joinView animated:YES completion:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取支持的地区列表
    self.view.backgroundColor=[UIColor whiteColor];
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"tab2.png"];
    
    
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44+statusBarHeight)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAdd)];
    UIBarButtonItem *joinButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickFind)];
    [navigationItem setTitle:@"Group"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [navigationItem setRightBarButtonItem:addButton animated:NO];
    [navigationItem setLeftBarButtonItem:joinButton];
    //[navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    [self.view addSubview:navigationBar];
    //添加搜索框
    search=[[UISearchBar alloc] init];
    search.frame=CGRectMake(0, 44+statusBarHeight, self.view.frame.size.width, 44);
    [self.view addSubview:search];
    
    
    //添加table
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 88+statusBarHeight, self.view.frame.size.width, self.view.bounds.size.height-(128+statusBarHeight)) style:UITableViewStylePlain];
    table.dataSource=self;
    table.delegate=self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    
    search.delegate=self;
    [SMS_MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [groupInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"CustomCellIdentifier";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell=[[CustomCell alloc] init];
        cell.delegate = self;
    }
    NSDictionary* group = [groupInfo objectAtIndex:indexPath.row];
    cell.recordid = [group objectForKey:@"group_id"];
    cell.name=[group objectForKey:@"group_name"];
    if([group objectForKey:@"group_title"] != [NSNull null])
    cell.nameDesc = [group objectForKey:@"group_title"];
    cell.index = (int)indexPath.row;
    cell.section = (int)[indexPath section];
    cell.updateTime=[group objectForKey:@"group_update_time"];
    cell.masterEmail = [group objectForKey:@"group_master_user_email"];
    cell.pwd = [group objectForKey:@"group_pwd"];
    
    int myindex=(int)(cell.index)%17+1;
    NSString* imagePath=[NSString stringWithFormat:@"p%d.png",myindex];
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
    return @"Group";
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView cellForRowAtIndexPath:indexPath] == nil)
        return;
    
    [self.view endEditing:YES];
    CustomCell* cell =(CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    servlet* detailGroup = [[servlet alloc]init];
    Owner* owner = [[[OwnerDAO sharedManager] findAll] objectAtIndex:0];
    [detailGroup.manager POST:@"http://192.168.1.108:8001/api/update_group/" parameters:@{@"user_email":owner.email,@"group_id":cell.recordid,@"update_time":cell.updateTime}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSDictionary* result=(NSDictionary* )responseObject;
        //NSLog(@"%@",responseObject);
        if([[(NSDictionary*)responseObject objectForKey:@"message"] isEqualToString:@"no need to update"]){
            groupDetailViewController* detail = [[groupDetailViewController alloc]init];
            detail.groupId = cell.recordid;
            detail.group_undate = cell.updateTime;
            detail.group_name =cell.name;
            detail.group_pwd = cell.pwd;
            detail.group_desc = cell.nameDesc;
            [self presentViewController:detail animated:YES completion:nil];
            
        //直接跳转到那个页面
        }
        else if([[(NSDictionary*)responseObject objectForKey:@"message"] isEqualToString:@"the user need init"]){
            initGroupViewController* initView = [[initGroupViewController alloc]init];
            initView.groupId = cell.recordid;
            initView.updateTime = cell.updateTime;
            initView.group_name  = cell.name;
            initView.group_pwd = cell.pwd;
            initView.group_desc = cell.nameDesc;
            [self presentViewController:initView animated:YES completion:nil];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    

//    NSLog(@"cell的按钮被点击了-第%d行", (int)indexPath.row);
    
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
    groupInfo=[NSMutableArray array];
    OwnerDAO* op = [OwnerDAO sharedManager];
    Owner* owner = (Owner*)[op.findAll objectAtIndex:0];
    servlet* getAll = [[servlet alloc]init];
    [getAll.manager POST:@"http://192.168.1.108:8001/api/get_all_group_message/" parameters:@{@"user_email":owner.email}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSDictionary* result=(NSDictionary* )responseObject;
        //NSLog(@"%@",responseObject);
        
        NSMutableArray* groupInfoArray  = [(NSDictionary*)responseObject objectForKey:@"data"];
        groupInfo = groupInfoArray;
        //[dict setObject:_other forKey:NSLocalizedString(@"toinvitefriends", nil)];
        //self.allNames = dict;
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [table reloadData];
        [SMS_MBProgressHUD hideHUDForView:self.view animated:YES];
        //NSString *str =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        // NSLog(@"%@",str);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
//    _addressBookData=[SMS_SDK addressBook];

}
@end
