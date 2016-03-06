//
//  initGroupViewController.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/22.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import "initGroupViewController.h"
#import "OwnerDAO.h"
#import "servlet.h"
#import "groupDetailViewController.h"
@interface initGroupViewController ()
{
    UITextField* _nameField;
    UITextField* _mailField;
    UITextField* _phoneField;
    NSString* email;
}
@end

@implementation initGroupViewController

-(void)clickLeftButton

{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
-(void)rightClick{
    servlet* initG = [[servlet alloc]init];
    [initG.manager POST:@"http://192.168.1.108:8001/api/init_group_user_message/" parameters:@{@"user_email":email,@"group_id":self.groupId,@"email":_mailField.text,@"phone":_phoneField.text,@"name":_nameField.text}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSDictionary* result=(NSDictionary* )responseObject;
        //NSLog(@"%@",responseObject);
        if([[(NSMutableDictionary*)responseObject objectForKey:@"success"]isEqualToNumber:@1]){
            UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"success" message:@"init information succeess" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
            OwnerDAO *op = [OwnerDAO sharedManager];
            Owner* newOwner = [[op findAll]objectAtIndex:0];
            newOwner.name = _nameField.text;
            newOwner.defaultEmail = _mailField.text;
            newOwner.defaultPhone = _phoneField.text;
            [op modify:newOwner];
            groupDetailViewController* detail = [[groupDetailViewController alloc]init];
            detail.group_undate = self.updateTime;
            detail.groupId = self.groupId;
            detail.group_name = self.group_name;
            detail.group_pwd = self.group_pwd;
            detail.group_desc =self.group_desc;
            [self presentViewController:detail animated:YES completion:nil];
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
    
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,45+statusBarHeight+50+statusBarHeight/4 , self.view.frame.size.width/4 , 35+statusBarHeight/4)];
    nameLabel.text =@"Name";
    [self.view addSubview:nameLabel];
    
    UILabel* mailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,75+statusBarHeight+75+statusBarHeight/4 , self.view.frame.size.width/4 , 35+statusBarHeight/4)];
    mailLabel.text =@"E-mail";
    [self.view addSubview:mailLabel];
    
    UILabel* phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,105+statusBarHeight*3/2+100, self.view.frame.size.width/4 , 35+statusBarHeight/4)];
    phoneLabel.text =@"Phone";
    [self.view addSubview:phoneLabel];
    
    
    UITextField* nameField = [[UITextField alloc]init];
    nameField.frame=CGRectMake(self.view.frame.size.width/4 , 45+statusBarHeight+50+statusBarHeight/4,self.view.frame.size.width/4*3-20 , 35+statusBarHeight/4);
    nameField.borderStyle=UITextBorderStyleBezel;
    nameField.placeholder=NSLocalizedString(@"name", nil);
    nameField.keyboardType=UIKeyboardAppearanceDefault;
    nameField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:nameField];
    
    UITextField* mailField = [[UITextField alloc]init];
    mailField.frame=CGRectMake(self.view.frame.size.width/4, 75+statusBarHeight+75+statusBarHeight/4,self.view.frame.size.width/4*3-20 , 35+statusBarHeight/4);
    mailField.borderStyle=UITextBorderStyleBezel;
    mailField.placeholder=NSLocalizedString(@"mail", nil);
    mailField.keyboardType=UIKeyboardAppearanceDefault;
    mailField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:mailField];
    
    UITextField* phoneField = [[UITextField alloc]init];
    phoneField.frame=CGRectMake(self.view.frame.size.width/4, 105+statusBarHeight*3/2+100,self.view.frame.size.width/4*3-20 , 35+statusBarHeight/4);
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
