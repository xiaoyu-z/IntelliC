#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <SMS_SDK/SMS_SDKResultHanderDef.h>
@interface InvitationViewControllerEx : UIViewController<UITableViewDataSource,UITableViewDelegate,ABNewPersonViewControllerDelegate>

-(void)setData:(NSString*)name;
-(void)setPhone:(NSString *)phone AndPhone2:(NSString*)phone2;
-(void)setId:(NSString*)recordId;
@end
