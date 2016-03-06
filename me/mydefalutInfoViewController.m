//
//  mydefalutInfoViewController.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/26.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import "mydefalutInfoViewController.h"
#import "OwnerDAO.h"
#import "servlet.h"
@interface mydefalutInfoViewController ()
{
    UITextField* _nameField;
    UITextField* _mailField;
    UITextField* _phoneField;
    NSString* email;
}
@end

@implementation mydefalutInfoViewController

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
    nameField.frame=CGRectMake(10, 55+statusBarHeight+50+statusBarHeight/4,self.view.frame.size.width-20 , 40+statusBarHeight/4);
    nameField.borderStyle=UITextBorderStyleBezel;
    nameField.placeholder=NSLocalizedString(@"name", nil);
    nameField.keyboardType=UIKeyboardAppearanceDefault;
    nameField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:nameField];
    
    UITextField* mailField = [[UITextField alloc]init];
    mailField.frame=CGRectMake(10, 85+statusBarHeight+75+statusBarHeight/4,self.view.frame.size.width-20 , 40+statusBarHeight/4);
    mailField.borderStyle=UITextBorderStyleBezel;
    mailField.placeholder=NSLocalizedString(@"mail", nil);
    mailField.keyboardType=UIKeyboardAppearanceDefault;
    mailField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:mailField];
    
    UITextField* phoneField = [[UITextField alloc]init];
    phoneField.frame=CGRectMake(10, 115+statusBarHeight*3/2+100,self.view.frame.size.width-20 , 40+statusBarHeight/4);
    phoneField.borderStyle=UITextBorderStyleBezel;
    phoneField.placeholder=NSLocalizedString(@"phone", nil);
    phoneField.keyboardType=UIKeyboardAppearanceDefault;
    phoneField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneField];
    OwnerDAO* op =[OwnerDAO sharedManager];
    
    Owner* owner = [[op findAll] objectAtIndex:0];
    [phoneField setText:owner.defaultPhone];
    [nameField setText:owner.name];
    [mailField setText:owner.defaultEmail];
    email = owner.email;
    _phoneField = phoneField;
    _nameField = nameField;
    _mailField =mailField;

    // Do any additional setup after loading the view.
}
-(void)rightClick{
    NSString* string = @"";
    if(self.groupId.count == 0){
        UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"" message:@"No Group" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }
    for(int i = 0;i<self.groupId.count;i++){
        NSString* str = @"";
        str = [NSString stringWithFormat:@"%@,",[self.groupId objectAtIndex:i]];
        string = [string stringByAppendingString:str];
        
    }

    NSString* newStr = [string substringToIndex:string.length-1];
    //NSLog(@"%@",newStr);
    servlet* defaultInfo = [[servlet alloc]init];
    
    [defaultInfo.manager POST:@"http://192.168.1.108:8001/api/change_user_message_all/" parameters:@{@"user_email":email,@"group_id":newStr,@"email":_mailField.text,@"phone":_phoneField.text,@"name":_nameField.text}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSDictionary* result=(NSDictionary* )responseObject;
        NSLog(@"%@",responseObject);
        if([[(NSMutableDictionary*)responseObject objectForKey:@"success"]isEqualToNumber:@1]){
            UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"success" message:@"Change all group information succeess" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            OwnerDAO *op = [OwnerDAO sharedManager];
            Owner* newOwner = [[op findAll]objectAtIndex:0];
            newOwner.name = _nameField.text;
            newOwner.defaultEmail = _mailField.text;
            newOwner.defaultPhone = _phoneField.text;
            [op modify:newOwner];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];



}
-(void)clickLeftButton{
    [self dismissViewControllerAnimated:YES completion:nil];

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
