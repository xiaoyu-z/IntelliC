#import "InvitationViewControllerEx.h"
#import <AddressBook/AddressBook.h>
#import <SMS_SDK/SMS_SDK.h>
#import <AddressBookUI/AddressBookUI.h>
#import <SMS_SDK/SMS_AddressBook.h>
@interface InvitationViewControllerEx ()
{
    NSString* _name;
    NSString* _phone;
    NSString* _phone2;
    NSString* _recordid;
    UITableView* _tableView;
    bool change;
}

@end

@implementation InvitationViewControllerEx

-(void)clickLeftButton

{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

-(void)setData:(NSString *)name
{
    _name=name;
}

-(void)setPhone:(NSString *)phone AndPhone2:(NSString*)phone2
{
    _phone=phone;
    _phone2=phone2;
}
-(void)setId:(NSString *)recordId{
    _recordid=recordId;

}
-(void)call{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phone];
    //NSLog(@"%@",_phone);
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
-(void)rightClick{
    
    //NSLog(@"%@",_recordid);
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    ABRecordRef record = ABAddressBookGetPersonWithRecordID(addressBook,(ABRecordID)[_recordid intValue]);
    ABNewPersonViewController *newPersonVC = [[ABNewPersonViewController alloc] init];
    
    newPersonVC.newPersonViewDelegate = self;
    newPersonVC.displayedPerson = record;
    newPersonVC.editing =YES;
    UINavigationController *newNavigationController = [[UINavigationController alloc]initWithRootViewController:newPersonVC];
    [self presentViewController:newNavigationController animated:NO completion:^{
    }];
    CFRelease(record);
    CFRelease(addressBook);
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

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView
       didCompleteWithNewPerson:(ABRecordRef)person
{
    NSMutableArray* _addressBookData=[SMS_SDK addressBook];
    for (int i=0; i<_addressBookData.count; i++) {
        SMS_AddressBook* person1=[_addressBookData objectAtIndex:i];
        if([person1.recordid isEqualToString:_recordid] && person1.phones ==nil){
            ABRecordID personID = [_recordid intValue];
            CFErrorRef error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, personID);
            // 设置电话号码
            ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(multi,  (__bridge CFTypeRef)_phone,
                                         kABPersonPhoneMobileLabel, NULL);
            ABRecordSetValue(person, kABPersonPhoneProperty, multi, &error);
            CFRelease(multi);
            ABAddressBookSave(addressBook, &error);
            CFRelease(addressBook);
            break;

        }
        else if([person1.recordid isEqualToString:_recordid]){
            //NSLog(@"%@",person1.phones);
            [self setPhone:person1.phones AndPhone2:nil];
            [self setData:person1.name];
            change = true;
            break;
        }

    }
    [_tableView reloadData];
    //CFRelease(person);
    [newPersonView dismissViewControllerAnimated:YES completion:^{
//        UIAlertView* alter = [[UIAlertView alloc]initWithTitle:@"success" message:@"modify contact success" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alter show];
    }];
}

-(void)sendInvite
{
    //发送短信
    //NSLog(@"send invitational message");
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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightClick)];
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setRightBarButtonItem:rightButton];
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
    
    
    
//    UILabel* label=[[UILabel alloc] init];
//    label.frame=CGRectMake(0, 146+statusBarHeight, self.view.frame.size.width, 27);
//    label.text=[NSString stringWithFormat:@"%@%@",_name,NSLocalizedString(@"notjoined", nil)];
//    label.textAlignment = UITextAlignmentCenter;
//    label.font = [UIFont fontWithName:@"Helvetica" size:13];
//    [self.view addSubview:label];

}
@end
