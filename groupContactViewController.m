//
//  groupContactViewController.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/23.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import "groupContactViewController.h"
#import <AddressBook/AddressBook.h>
#import <SMS_SDK/SMS_SDK.h>
#import <AddressBookUI/AddressBookUI.h>
#import <SMS_SDK/SMS_AddressBook.h>
#import "servlet.h"
#import "OwnerDAO.h"
@interface groupContactViewController ()
{    NSString* _name;
    NSString* _phone;
    NSString* _phone2;
    NSString* _recordid;
    UITableView* _tableView;
}
@end

@implementation groupContactViewController

-(void)clickLeftButton

{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

-(void)setName:(NSString *)name
{
    _name=name;
}

-(void)setPhone:(NSString *)phone AndPhone2:(NSString*)phone2
{
    _phone=phone;
    _phone2=phone2;
}
-(void)setContactID:(NSString *)email{
    _recordid=email ;
    
}
-(void)call{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phone];
    //NSLog(@"%@",_phone);
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark -
#pragma mark ABNewPersonViewController 委托方法实现
//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
//{
//
//    ABPersonViewController*ViewPicker = [[ABPersonViewController alloc] init];
//    ViewPicker.personViewDelegate = self;
//    [ViewPicker setDisplayedPerson:person];
//    ViewPicker.allowsEditing = YES;
//    //[peoplePicker pushViewController:personViewPicker animated:YES];
//    return NO;
//
//
//}


-(void)sendInvite
{
    //发送短信
    NSLog(@"send invitational message");
    if ([_phone2 length]>0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                      message:NSLocalizedString(@"choosephonenumber", nil)
                                                     delegate:self
                                            cancelButtonTitle:_phone
                                            otherButtonTitles:_phone2, nil];
        [alert show];
    }
    else
    {
        [SMS_SDK sendSMS:_phone AndMessage:NSLocalizedString(@"smsmessage", nil)];
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text=_name;
    cell.imageView.image=[UIImage imageNamed:@"2.png"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"phonecode", nil),_phone,_phone2?_phone2:@""];
    
    return cell;
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0+statusBarHeight, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    //把导航栏集合添加入导航栏中，设置动画关闭

    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44+statusBarHeight, self.view.frame.size.width, 80) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:NSLocalizedString(@"sendinvite", nil) forState:UIControlStateNormal];
    NSString *icon = [NSString stringWithFormat:@"smssdk.bundle/button4.png"];
    [btn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.frame=CGRectMake(15, 198+statusBarHeight, self.view.frame.size.width-30, 42);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendInvite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton* callbtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [callbtn setTitle:NSLocalizedString(@"Call", nil) forState:UIControlStateNormal];
    [callbtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    callbtn.frame=CGRectMake(15, 250+statusBarHeight, self.view.frame.size.width-30, 42);
    [callbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callbtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callbtn];
    
    UIButton* removebtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [removebtn setTitle:NSLocalizedString(@"Remove", nil) forState:UIControlStateNormal];
    [removebtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    removebtn.frame=CGRectMake(15, 300+statusBarHeight, self.view.frame.size.width-30, 42);
    [removebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [removebtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    removebtn.hidden = YES;
    if(self.isManager){
        removebtn.hidden = NO;
    }
    [self.view addSubview:removebtn];
    
    
    
    //    UILabel* label=[[UILabel alloc] init];
    //    label.frame=CGRectMake(0, 146+statusBarHeight, self.view.frame.size.width, 27);
    //    label.text=[NSString stringWithFormat:@"%@%@",_name,NSLocalizedString(@"notjoined", nil)];
    //    label.textAlignment = UITextAlignmentCenter;
    //    label.font = [UIFont fontWithName:@"Helvetica" size:13];
    //    [self.view addSubview:label];
    
}
-(void)remove{
    Owner* owner = [[[OwnerDAO sharedManager] findAll]objectAtIndex:0];
    servlet* remove = [[servlet alloc]init];
    
    [remove.manager POST:@"http://192.168.1.108:8001/api/delete_group_user/" parameters:@{@"user_email":owner.email,@"group_id":self.groupId,@"user_email_remove":_recordid}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSDictionary* result=(NSDictionary* )responseObject;
        //NSLog(@"%@",responseObject);
        if([[(NSMutableDictionary*)responseObject objectForKey:@"success"]isEqualToNumber:@1]){
                UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"success" message:@"Delete Group Succeess" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];



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
