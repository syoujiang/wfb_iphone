//
//  LoginViewController.h
//  test3
//
//  Created by jiang ming on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "GCDAsyncSocket.h"
#import "yUIAlertViewWithAI.h"


@class RootViewController;

@interface LoginViewController : UIViewController
{
    RootViewController *fatherView;
}
@property (retain, nonatomic) IBOutlet UITextField *LoginPasswd;
@property (retain, nonatomic) IBOutlet UITextField *LoginName;
-(IBAction)LoginClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *LoginButton;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *fatherView;
- (IBAction)LoginBack;
@property (strong, nonatomic) yUIAlertViewWithAI *myAlert;
@end
