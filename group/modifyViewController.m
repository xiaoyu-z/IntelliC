//
//  modifyViewController.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/23.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//
#import "servlet.h"
#import "modifyViewController.h"
#import "OwnerDAO.h"
@interface modifyViewController ()
{
    UITextField* _nameField;
    UITextField* _mailField;
    UITextField* _phoneField;
    NSString* email;
}
@end

@implementation modifyViewController
-(void)clickLeftButton

{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
-(void)rightClick{
    servlet* update = [[servlet alloc]init];
    [update.manager POST:@"http://192.168.1.108:8001/api/change_user_message/" parameters:@{@"user_email":email,@"group_id":self.groupId,@"new_email":_mailField.text,@"new_phone":_phoneField.text,@"new_name":_nameField.text}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSDictionary* result=(NSDictionary* )responseObject;
        //NSLog(@"%@",responseObject);
        if([[(NSDictionary*)responseObject objectForKey:@"success"] isEqualToNumber:@1]){
        UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"success" message:@"Change information succeess" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}


- (void)viewDidLoad {
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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightClick)];
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setRightBarButtonItem:rightButton];
    [self.view addSubview:navigationBar];
    
    UITextField* nameField = [[UITextField alloc]init];
    nameField.frame=CGRectMake(10, 25+statusBarHeight+50+statusBarHeight/4,self.view.frame.size.width-20 , 40+statusBarHeight/4);
    nameField.borderStyle=UITextBorderStyleBezel;
    nameField.placeholder=NSLocalizedString(@"name", nil);
    nameField.keyboardType=UIKeyboardAppearanceDefault;
    nameField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:nameField];
    
    UITextField* mailField = [[UITextField alloc]init];
    mailField.frame=CGRectMake(10, 55+statusBarHeight+75+statusBarHeight/4,self.view.frame.size.width-20 , 40+statusBarHeight/4);
    mailField.borderStyle=UITextBorderStyleBezel;
    mailField.placeholder=NSLocalizedString(@"mail", nil);
    mailField.keyboardType=UIKeyboardAppearanceDefault;
    mailField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:mailField];
    
    UITextField* phoneField = [[UITextField alloc]init];
    phoneField.frame=CGRectMake(10, 80+statusBarHeight*3/2+100,self.view.frame.size.width-20 , 40+statusBarHeight/4);
    phoneField.borderStyle=UITextBorderStyleBezel;
    phoneField.placeholder=NSLocalizedString(@"phone", nil);
    phoneField.keyboardType=UIKeyboardAppearanceDefault;
    phoneField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneField];
    
    UIButton* quit = [[UIButton alloc]initWithFrame:CGRectMake(10, 285+statusBarHeight*7/4, self.view.frame.size.width-20, 40)];
    [quit setTitle:@"Quit" forState:UIControlStateNormal];
    NSString *icon = [NSString stringWithFormat:@"smssdk.bundle/button4.png"];
    [quit setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [quit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quit addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [quit setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview: quit];
    
    _phoneField = phoneField;
    _nameField = nameField;
    _mailField =mailField;
    
    Owner *owner = [[[OwnerDAO sharedManager] findAll]objectAtIndex:0];
    [_mailField setText:self.email];
    [_nameField setText:self.name];
    [_phoneField setText:self.phone];
    email = owner.email;
    
    // Do any additional setup after loading the view.
}
-(void)quit{
    servlet* quit = [[servlet alloc]init];
    [quit.manager POST:@"http://192.168.1.108:8001/api/leave_group/" parameters:@{@"user_email":email,@"group_id":self.groupId}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSDictionary* result=(NSDictionary* )responseObject;
        //NSLog(@"%@",responseObject);
        if([[(NSDictionary*)responseObject objectForKey:@"success"] isEqualToNumber:@1]){
            UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *groupView=[secondStroyBoard instantiateViewControllerWithIdentifier:@"group"];
            groupView.selectedIndex = 1;
            [self presentModalViewController:groupView animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
