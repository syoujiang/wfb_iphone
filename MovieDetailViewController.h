//
//  MovieDetailViewController.h
//  test3
//
//  Created by jiang ming on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface MovieDetailViewController : UIViewController<ZBarReaderDelegate>
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (copy, nonatomic) NSString *message;
@end
