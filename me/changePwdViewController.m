//
//  changePwdViewController.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/26.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import "changePwdViewController.h"
#import "servlet.h"
#import "OwnerDAO.h"
@interface changePwdViewController ()
{   UITextField* oldPwd;
    UITextField* newPwd_1;
    UITextField* newPwd_2;

}

@end

@implementation changePwdViewController

-(void)clickLeftButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightClick{
    
    //NSLog(@"%@,%@",newPwd_1.text,newPwd_2.text);
    if(![newPwd_1.text isEqualToString: newPwd_2.text])
        return;
    Owner * owner = [[[OwnerDAO sharedManager]findAll] objectAtIndex:0];
    servlet* changePwd = [[servlet alloc]init];
    [changePwd.manager POST:@"http://192.168.1.108:8001/api/change_pwd/" parameters:@{@"user_email":owner.email,@"old_pwd":oldPwd.text,@"new_pwd":newPwd_1.text}success:^(AFHTTPRequestOperation *operation, id responseObject) {
    // NSDictionary* result=(NSDictionary* )responseObject;
    //NSLog(@"%@",responseObject);
    if([[(NSMutableDictionary*)responseObject objectForKey:@"success"]isEqualToNumber:@1]){
        UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"success" message:@"Change password succeess" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        [self dismissViewControllerAnimated:YES completion:nil];
            }
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"error:%@",error);
}];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    UITextField* oldPwdField = [[UITextField alloc]init];
    oldPwdField.frame=CGRectMake(10, 55+statusBarHeight+50+statusBarHeight/4,self.view.frame.size.width-20 , 40+statusBarHeight/4);
    oldPwdField.borderStyle=UITextBorderStyleBezel;
    oldPwdField.placeholder=@"your password";
    oldPwdField.keyboardType=UIKeyboardAppearanceDefault;
    oldPwdField.clearButtonMode=UITextFieldViewModeWhileEditing;
    oldPwdField.secureTextEntry = YES;
    [self.view addSubview:oldPwdField];
    
    UITextField* newPwdField = [[UITextField alloc]init];
    newPwdField.frame=CGRectMake(10, 125+statusBarHeight+55+statusBarHeight/4,self.view.frame.size.width-20 , 40+statusBarHeight/4);
    newPwdField.borderStyle=UITextBorderStyleBezel;
    newPwdField.placeholder=@"New password";
    newPwdField.keyboardType=UIKeyboardAppearanceDefault;
    newPwdField.clearButtonMode=UITextFieldViewModeWhileEditing;
    newPwdField.secureTextEntry = YES;
    [self.view addSubview:newPwdField];
    
    UITextField* newPField = [[UITextField alloc]init];
    newPField.frame=CGRectMake(10, 125+statusBarHeight*3/2+100,self.view.frame.size.width-20 , 40+statusBarHeight/4);
    newPField.borderStyle=UITextBorderStyleBezel;
    newPField.placeholder=@"Input New Passord Again";
    newPField.keyboardType=UIKeyboardAppearanceDefault;
    newPField.clearButtonMode=UITextFieldViewModeWhileEditing;
    newPField.secureTextEntry = YES;
    [self.view addSubview:newPField];

    oldPwd = oldPwdField;
    newPwd_1 = newPwdField;
    newPwd_2 = newPField;
    
    
    // Do any additional setup after loading the view.
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
