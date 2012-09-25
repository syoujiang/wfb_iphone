//
//  RootViewController.h
//  test3
//
//  Created by jiang ming on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "Share_data.h"

@class LoginViewController;
@interface RootViewController : UITableViewController
{
    LoginViewController *loginview;
}
@property (strong, nonatomic) NSArray *controllerList;
@property (nonatomic, retain) LoginViewController *loginview;
@end
