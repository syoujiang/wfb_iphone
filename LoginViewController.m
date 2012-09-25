//
//  LoginViewController.m
//  test3
//
//  Created by jiang ming on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RootViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize LoginPasswd;
@synthesize LoginName;

@synthesize navController;
@synthesize window;
@synthesize LoginButton;
@synthesize fatherView;
@synthesize myAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)LoginClick:(id)sender
{
    unsigned int user_len = [LoginName.text length];
    unsigned int passwd_len = [LoginPasswd.text length];
    UIAlertView *alertView;
    if (user_len <=0 ) 
    {
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView setTag:1];
        [alertView show];
        [alertView release];
        return;
    }
    if (passwd_len <=0) 
    {
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView setTag:1];
        [alertView show];
        [alertView release];
        return;
    }
 //   [LoginName resignFirstResponder];
 //   [LoginPasswd resignFirstResponder];
    
    /* socket send message */
    [Share_data sharedShare_data].sendbuf = [@"<option>accountlogin</option>" 
                                         stringByAppendingFormat: @"<cleanname>%@</cleanname><cleannamepwd>%@</cleannamepwd>\r\n",
                                         LoginName.text,LoginPasswd.text];
    
    
    [self sendTCPMsg];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    //[commdata stopSpinner];
    [myAlert dismissWithClickedButtonIndex:0 animated:NO];
    if((err != Nil)&&(GCDAsyncSocketConnectTimeoutError == err.code))
    {
        NSLog(@"socketDidDisconnect %@",err);
        [Share_data alertInfo:@"超时" msg:@"连接超时，请重试或者检查网络"];
        [super viewDidLoad];
    }
    
}

/* recv data */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    UIAlertView *alertView;
    
    NSRange range =[response rangeOfString:@"passworderror"];
    NSLog(@"%d %d", range.length, range.location);
    if(range.length > 0)
    {
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" 
                                              message:@"您的用户名和密码错误" 
                                             delegate:self 
                                    cancelButtonTitle:@"确定" 
                                    otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    /* log in ok */
    // passwordok<permtype>bankpeople</permtype><cleancar>false<cleancar>
    else
    {
        NSString *usertype = [Share_data mid:response start:@"<permtype>" end:@"</permtype>"];
        NSLog(@"%@", usertype); 
        if ([usertype isEqualToString:@"jdsypeople"]) 
        {
            [Share_data sharedShare_data].LoginType = JDSY_LOGIN;
        }
        else if([usertype isEqualToString:@"bankpeople"]) 
        {
            [Share_data sharedShare_data].LoginType = BANK_LOGIN;
        }
        else
        {
            [Share_data sharedShare_data].LoginType = LOGIN_NO;
        }
        [Share_data sharedShare_data].Username = LoginName.text;
        [self LoginBack];
        
    }

    
    
    NSLog(@"read data %@ %ld",response,tag);
    [response release];
    [sock disconnect];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSString *request = [Share_data sharedShare_data].sendbuf;
    NSLog(@"send buf is %@", request);
    NSData *requestData = [request dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:requestData withTimeout:-1 tag:0];
    [sock readDataWithTimeout:-1 tag:0];
}

-(void)sendTCPMsg
{
    NSError *error=nil;
    
    NSString *host=HOST;
    uint16_t port = PORT;
    
    // [self startSpinner];
    //[commdata startSpinner];
    myAlert = [[yUIAlertViewWithAI alloc]initWithTitle:@"登录中" isActiveAI:YES];
    [myAlert show];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    GCDAsyncSocket *mysock = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:mainQueue];
    if (![mysock connectToHost:host onPort:port withTimeout:5.0f error:&error])
    {
        NSLog(@"connected host error %@",error);
    }
    [mysock release];
    
}

-(void)socketDid:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDid enter");
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [self setLoginName:nil];
    [self setLoginPasswd:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)LoginBack {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self dismissModalViewControllerAnimated:YES];
    
    RootViewController *root = [[RootViewController alloc] initWithStyle:UITableViewStylePlain]; 
    self.navController = [[UINavigationController alloc] initWithRootViewController:root]; 
    [self.window addSubview:navController.view];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
- (void)dealloc {
    [LoginName release];
    [LoginPasswd release];
    [super dealloc];
}
@end
