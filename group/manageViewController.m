//
//  manageViewController.m
//  IntelliC
//
//  Created by 郑啸宇 on 15/7/23.
//  Copyright (c) 2015年 冰弦鸾笙. All rights reserved.
//

#import "manageViewController.h"
#import "servlet.h"
#import "OwnerDAO.h"
#import "manageContactViewController.h"
@interface manageViewController (){
    UITextField* nameField;
    UITextField* descField;
}

@end

@implementation manageViewController

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
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil)style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(clickRightButton)];
    
    [navigationItem setTitle:@"Manage Group"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setRightBarButtonItem:rightButton];
    [self.view addSubview:navigationBar];
    
    nameField = [[UITextField alloc]init];
    nameField.frame=CGRectMake(10, 55+statusBarHeight+statusBarHeight/4,self.view.frame.size.width-20 , 40);
    nameField.borderStyle=UITextBorderStyleBezel;
    nameField.placeholder=NSLocalizedString(@"name", nil);
    nameField.keyboardType=UIKeyboardAppearanceDefault;
    nameField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:nameField];
    
    descField = [[UITextField alloc]init];
    descField.frame=CGRectMake(10, 105+statusBarHeight+statusBarHeight/4,self.view.frame.size.width-20 , 40);
    descField.borderStyle=UITextBorderStyleBezel;
    descField.placeholder=NSLocalizedString(@"group description", nil);
    descField.keyboardType=UIKeyboardAppearanceDefault;
    descField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:descField];
    
    UIButton* change = [[UIButton alloc]initWithFrame:CGRectMake(10, 155+statusBarHeight*5/4, self.view.frame.size.width-20, 40)];
    [change setTitle:@"Change administrator" forState:UIControlStateNormal];
    NSString *icon = [NSString stringWithFormat:@"smssdk.bundle/button4.png"];
    [change setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [change setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [change addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [change setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview: change];
    
    UIButton* delete = [[UIButton alloc]initWithFrame:CGRectMake(10, 205+statusBarHeight*5/4, self.view.frame.size.width-20, 40)];
    [delete setTitle:@"Delete Group" forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [delete setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delete setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview: delete];
    
    [descField setText:self.groupDesc];
    [nameField setText:self.groupName];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //改名字 换管理员 删群组 删人
    // Dispose of any resources that can be recreated.
}
-(void)change{
    manageContactViewController* changeManager = [[manageContactViewController alloc]init];
    changeManager.other = self.groupInfo;
    changeManager.groupEmail = self.Emailarray;
    changeManager.groupId = self.groupId;
    [self presentViewController:changeManager animated:YES completion:nil];

}

-(void)delete{
    Owner *owner =[[[OwnerDAO sharedManager]findAll] objectAtIndex:0];
    servlet* delete = [[servlet alloc]init];
    [delete.manager POST:@"http://192.168.1.108:8001/api/drop_group/" parameters:@{@"user_email":owner.email,@"group_id":self.groupId}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSDictionary* result=(NSDictionary* )responseObject;
        //NSLog(@"%@",responseObject);
        if([[(NSMutableDictionary*)responseObject objectForKey:@"success"]isEqualToNumber:@1]){
            UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"success" message:@"Delete Group  Succeess" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
            UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *groupView=[secondStroyBoard instantiateViewControllerWithIdentifier:@"group"];
            groupView.selectedIndex = 1;
            [self presentModalViewController:groupView animated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}
-(void)clickLeftButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickRightButton{
    Owner *owner =[[[OwnerDAO sharedManager]findAll] objectAtIndex:0];
    servlet* update = [[servlet alloc]init];
    [update.manager POST:@"http://192.168.1.108:8001/api/insert_title/" parameters:@{@"user_email":owner.email,@"group_id":self.groupId,@"new_title":descField.text}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSDictionary* result=(NSDictionary* )responseObject;
        //NSLog(@"%@",responseObject);
        if([[(NSMutableDictionary*)responseObject objectForKey:@"success"]isEqualToNumber:@1]){
                UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"success" message:@"Change title succeess" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
