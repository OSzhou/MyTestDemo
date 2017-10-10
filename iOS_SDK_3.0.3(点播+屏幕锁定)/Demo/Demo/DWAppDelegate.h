#import <UIKit/UIKit.h>
#import "DWUploadItem.h"
#import "DWSDK.h"

@interface DWAppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL isDownloaded;
}
@property (assign, nonatomic)BOOL isDownloaded;
@property (strong, nonatomic)UIWindow *window;
@property (nonatomic, assign) UIInterfaceOrientationMask faceOrientationMask;

@property (strong, nonatomic)DWUploadItems *uploadItems;



@end
