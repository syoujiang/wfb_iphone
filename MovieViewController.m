//
//  MovieViewController.m
//  test3
//
//  Created by jiang ming on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieDetailViewController.h"
#import "AppDelegate.h"
#import "yUIAlertViewWithAI.h"


@interface MovieViewController ()
@property (strong, nonatomic) MovieDetailViewController *childController; 
@end

@implementation MovieViewController
@synthesize movieList;
@synthesize imageView;
@synthesize nameLabel;
@synthesize decLabel;
@synthesize childController;
@synthesize image;
@synthesize name;
@synthesize dec;
@synthesize myAlert;

@synthesize rep_code;
@synthesize rep_result;
@synthesize rep_err_judge;
@synthesize rep_replace_no;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)buttonscan
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
   // resultText.text = symbol.data;
    NSLog(@"%@",symbol.data);
    [Share_data sharedShare_data].barcode = symbol.data;
      
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    if (ATM_CLEAR == [Share_data sharedShare_data].ViewType) 
    {
        [Share_data sharedShare_data].sendbuf = [@"<option>selectmysql</option>" 
                                                         stringByAppendingFormat: @"<barcode>%@</barcode>\r\n",
                                                         [Share_data sharedShare_data].barcode];
    }
    else if (MACHINEBOX_REPAIR == [Share_data sharedShare_data].ViewType) 
    {
        [Share_data sharedShare_data].sendbuf = [@"<option>ATMboxInfoGet</option>" 
                                                 stringByAppendingFormat: @"<barcode>%@</barcode>\r\n",
                                                 [Share_data sharedShare_data].barcode];      
    }
    else if (MACHINEBOX_GOOD_RECV == [Share_data sharedShare_data].ViewType) 
    {
        [Share_data sharedShare_data].sendbuf = [@"<option>goodmachineboxsend</option>" 
                                                 stringByAppendingFormat: @"<barcode>%@</barcode><SendPeople>%@</SendPeople><RecvPeople>%@</RecvPeople>\r\n",
                                                 [Share_data sharedShare_data].barcode,
                                                 [Share_data sharedShare_data].Username,
                                                 [Share_data sharedShare_data].goodsendpeople];
    }    
    else if (MACHINEBOX_BAD_SEND == [Share_data sharedShare_data].ViewType) 
    {
        [Share_data sharedShare_data].sendbuf = [@"<option>badmachineboxaccept</option>" 
                                                 stringByAppendingFormat: @"<barcode>%@</barcode><SendPeople>%@</SendPeople><RecvPeople>%@</RecvPeople>\r\n",
                                                 [Share_data sharedShare_data].barcode,
                                                 [Share_data sharedShare_data].badrecvpeople,
                                                 [Share_data sharedShare_data].Username];
    }
    [self sendTCPMsg];
 //   NSLog(@"%@",[commdata sharedcommdata].sendbuf);

}

-(void)sendmessage
{
    NSLog(@"send message");
    NSString *alertmessage = nil;
    if([Share_data sharedShare_data].barcode == nil)
    {
        alertmessage = @"请先扫描条码";
        UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:alertmessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlert1 show]; 
        [myAlert1 release];
        return;
    }
    if (ATM_CLEAR == [Share_data sharedShare_data].ViewType) 
    {
        do {
            if ([[Share_data sharedShare_data].selectStatuesString count] == 0)
            {
                alertmessage = @"请选择设备状态";
            }
            if ([[Share_data sharedShare_data].selectSafeString count] == 0)
            {
                alertmessage = @"请选择安全警告";
            }
        } while (0);
        if(nil != alertmessage)
        {
             UIAlertView *myAlert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:alertmessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [myAlert1 show]; 
            [myAlert1 release];
            return;
        }
        [Share_data sharedShare_data].sendbuf = [@"<option>insertmysql</option>" 
                                             stringByAppendingFormat: 
                                             @"<barcode>%@</barcode><estatus>%@</estatus><weather>%@</weather><clean>%@</clean><safe>%@</safe>\r\n",
                                             [Share_data sharedShare_data].barcode,
                                             [[Share_data sharedShare_data].selectStatuesString componentsJoinedByString:@"|"],
                                             [Share_data sharedShare_data].selectWeather,
                                             [Share_data sharedShare_data].Username,
                                             [[Share_data sharedShare_data].selectSafeString componentsJoinedByString:@"|"]
                                             ];
    }
    else if (MACHINEBOX_REPAIR == [Share_data sharedShare_data].ViewType) 
    {
        [Share_data sharedShare_data].sendbuf = [@"<option>badmachineboxrepair</option>" 
                                                 stringByAppendingFormat: @"<barcode>%@</barcode><id>%@</id><repairname>%@</repairname><failjudeg>%@</failjudeg><repairtype>%@</repairtype><replacenum>%@</replacenum>\r\n",
                                                 [Share_data sharedShare_data].barcode,
                                                 [Share_data sharedShare_data].machine_id,
                                                 [Share_data sharedShare_data].Username,
                                                 [[Share_data sharedShare_data].machine_failjudge_select componentsJoinedByString:@","],
                                                 [Share_data sharedShare_data].machine_repairtype_select,
                                                 [[Share_data sharedShare_data].machine_replacenum_select componentsJoinedByString:@","]
                                                 ];
    }
    else if (MACHINEBOX_GOOD_RECV == [Share_data sharedShare_data].ViewType) 
    {
        [Share_data sharedShare_data].sendbuf = [@"<option>goodmachineboxsend</option>" 
                                             stringByAppendingFormat: @"<barcode>%@</barcode><SendPeople>%@</SendPeople><RecvPeople>%@</RecvPeople>\r\n",
                                             [Share_data sharedShare_data].barcode,
                                             [Share_data sharedShare_data].Username,
                                             [Share_data sharedShare_data].goodsendpeople];
    }    
    else if (MACHINEBOX_BAD_SEND == [Share_data sharedShare_data].ViewType) 
    {
        [Share_data sharedShare_data].sendbuf = [@"<option>badmachineboxaccept</option>" 
                                                 stringByAppendingFormat: @"<barcode>%@</barcode><SendPeople>%@</SendPeople><RecvPeople>%@</RecvPeople>\r\n",
                                                 [Share_data sharedShare_data].barcode,
                                                 [Share_data sharedShare_data].badrecvpeople,
                                                 [Share_data sharedShare_data].Username];
    }
    
    NSLog(@" send message is %@",[Share_data sharedShare_data].sendbuf);
     [self sendTCPMsg];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ( JDSY_LOGIN == [Share_data sharedShare_data].LoginType)
    {
        if([Share_data sharedShare_data].ViewType == ATM_CLEAR)
        {
            NSArray *array = [[[NSArray alloc] initWithObjects:@"条形码", @"服务银行", @"保洁网点",
                              @"设备状态", @"天气情况", @"保洁人", @"安全警告", nil]autorelease];
            self.movieList = array;
        }
        else
        {
            
            NSArray *array = [[[NSArray alloc] initWithObjects:@"条形码", @"故障判定", @"更换部件",
                              @"维修结论", nil]autorelease];
            self.movieList = array;
        }
    }
    else if ( BANK_LOGIN == [Share_data sharedShare_data].LoginType)
    {
        if([Share_data sharedShare_data].ViewType == MACHINEBOX_BAD_SEND)
        {
            NSArray *array = [[[NSArray alloc] initWithObjects:@"条形码", @"接收人", nil]autorelease];
            self.movieList = array;
        }
        else
        {
            
            NSArray *array = [[[NSArray alloc] initWithObjects:@"条形码", @"送出人", nil]autorelease];
            self.movieList = array;
        }
        
    }
    NSLog(@"type is %d ",[Share_data sharedShare_data].ViewType);
    UIBarButtonItem *anotherbutton= [[UIBarButtonItem alloc]initWithTitle:@"发送" 
                                                                    style:UIBarButtonItemStylePlain 
                                                                   target:self 
                                                                   action:@selector(sendmessage)];
    
    self.navigationItem.rightBarButtonItem=anotherbutton;
    [anotherbutton release];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setNameLabel:nil];
    [self setDecLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.movieList = nil;
    self.childController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   // return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return(YES);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [movieList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MovieTableViewCell = @"MovieTableViewCell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: MovieTableViewCell]; 
    
    if (cell == nil) { 
    /*    cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: MovieTableViewCell]; 
    */
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MovieTableViewCell]autorelease];
    }
    NSUInteger row = [indexPath row]; 
   // NSString *movieTitle = [movieList objectAtIndex:row];
    //这里设置每一行显示的文本为所对应的View Controller的标题
   // cell.textLabel.text = movieTitle;
    if ( JDSY_LOGIN == [Share_data sharedShare_data].LoginType)
    {
        if (ATM_CLEAR == [Share_data sharedShare_data].ViewType) 
        {
        switch (row) {
            case 0:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"条形码";
                cell.detailTextLabel.text = [Share_data sharedShare_data].barcode;
                break;
            case 1:
             //   cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"服务银行";
                cell.detailTextLabel.text = [Share_data sharedShare_data].atm_serverbank;
                break;
            case 2:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"保洁网点";
                cell.detailTextLabel.text = [Share_data sharedShare_data].atm_net;
                break;
            case 3:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"设备状态";
              cell.detailTextLabel.text = @"请选择";
                cell.tag = 1;
                break;
            case 4:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"天气状况";
                cell.detailTextLabel.text = [Share_data sharedShare_data].selectWeather;
                break;
            case 5:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"保洁人";
                cell.detailTextLabel.text = [Share_data sharedShare_data].Username;
                break;
            case 6:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"安全警告";
                cell.detailTextLabel.text = @"请选择";
                break;
            default:
                break;
            }
        }
        else if (MACHINEBOX_REPAIR == [Share_data sharedShare_data].ViewType) 
        {
        switch (row) {
            case 0:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"条形码";
                cell.detailTextLabel.text = [Share_data sharedShare_data].barcode;
                break;
            case 1:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"故障判定";
                cell.detailTextLabel.text = @"请选择";
                break;
            case 2:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"更换部件";
                cell.detailTextLabel.text = @"请选择";
                break;
            case 3:
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"维修结论";
                cell.detailTextLabel.text = [Share_data sharedShare_data].machine_repairtype_select;
                cell.tag = 1;
                break;
            default:
                break;
            }
        }
    }
    else if ( BANK_LOGIN == [Share_data sharedShare_data].LoginType)
    {
        if (MACHINEBOX_BAD_SEND == [Share_data sharedShare_data].ViewType) 
        {
            switch (row) {
                case 0:
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = [self.movieList objectAtIndex:row];
                    cell.detailTextLabel.text = [Share_data sharedShare_data].barcode;
                    break;
                case 1:
                    //   cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = [self.movieList objectAtIndex:row];
                    cell.detailTextLabel.text = [Share_data sharedShare_data].badrecvpeople;
                    break;
                default:
                    break;
            }
        }
        else 
        {
            switch (row) {
                case 0:
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = [self.movieList objectAtIndex:row];
                    cell.detailTextLabel.text = self.rep_code;
                    break;
                case 1:
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = [self.movieList objectAtIndex:row];
                    cell.detailTextLabel.text = [Share_data sharedShare_data].goodsendpeople;
                    break;
                default:
                    break;
            }
        }

    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSLog(@"fkkkl %d",indexPath.row);
    //ZBarReaderViewController *reader = [[ZBarReaderViewController new]autorelease];
    
    NSMutableArray *array = [[[NSMutableArray alloc]init]autorelease];
    SelectViewController *movie2ViewController = [[[SelectViewController alloc] initWithStyle:UITableViewStylePlain]autorelease]; 
    if (ATM_CLEAR == [Share_data sharedShare_data].ViewType) 
    {
        switch (indexPath.row) {
            case 0:
                // ADD: present a barcode reader that scans from the camera feed
                [self buttonscan];
                break;
#if 0
            case 1:
                [Share_data sharedShare_data].barcode = @"W.10010";
                [Share_data sharedShare_data].sendbuf = [@"<option>selectmysql</option>" 
                                                         stringByAppendingFormat: @"<barcode>%@</barcode>\r\n",
                                                         [Share_data sharedShare_data].barcode];
                [self sendTCPMsg];
                break;
#endif
            case 3:
                movie2ViewController.title = @"设备状态";  
                [Share_data sharedShare_data].arrayType = ARRAY_EQUIP;
                [array addObject:movie2ViewController];
                UITableViewController *nextController = [array objectAtIndex:0]; 
                [self.navigationController pushViewController:nextController animated:YES];
                break;
            case 4:
                if([Share_data sharedShare_data].barcode == nil)
                {
                    UIAlertView *myAlert2 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先扫描条码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [myAlert2 show]; 
                    [myAlert2 release];
                    return;
                }
                movie2ViewController.title = @"天气状况";  
                [Share_data sharedShare_data].arrayType = ARRAY_WEATHER;
                UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
                actionSheet.title = @"请选择天气状况";
                actionSheet.delegate = self;
                for(NSString *obj in [Share_data sharedShare_data].atm_weather)
                {
                    [actionSheet addButtonWithTitle:obj];
                }
                actionSheet.tag = ACTION_TAG_ATM_WEATHER;
                actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                [actionSheet showInView:self.view];
                [actionSheet release];
                break;
            case 6:
                movie2ViewController.title = @"安全警告";  
                [Share_data sharedShare_data].arrayType = ARRAY_SAFEWARN;
                [array addObject:movie2ViewController];
                UITableViewController *safenextController = [array objectAtIndex:0]; 
                [self.navigationController pushViewController:safenextController animated:YES];
                break;
            default:
                break;
        }
        NSLog(@"type is %d",[Share_data sharedShare_data].arrayType);
    }
    else if (MACHINEBOX_REPAIR == [Share_data sharedShare_data].ViewType) 
    {
        switch (indexPath.row) {
            case 0:
#if 1                
                // ADD: present a barcode reader that scans from the camera feed
                [self buttonscan];
#else               
                [Share_data sharedShare_data].barcode = @"W.10010";
                [Share_data sharedShare_data].sendbuf = [@"<option>ATMboxInfoGet</option>" 
                                                         stringByAppendingFormat: @"<barcode>%@</barcode>\r\n",
                                                         [Share_data sharedShare_data].barcode];
                [self sendTCPMsg];
#endif
                break;
            case 1:
                [Share_data sharedShare_data].arrayType = ARRAY_FAIL_JUDGE;
                movie2ViewController.title = @"故障判定";  
                [array addObject:movie2ViewController];
                UITableViewController *nextController = [array objectAtIndex:0]; 
                [self.navigationController pushViewController:nextController animated:YES];
                break;
            case 2:
                [Share_data sharedShare_data].arrayType = ARRAY_REPLACE_NUM;
                movie2ViewController.title = @"更换部件";  
                [array addObject:movie2ViewController];
                UITableViewController *nextController2 = [array objectAtIndex:0]; 
                [self.navigationController pushViewController:nextController2 animated:YES];
                break;

            case 3:
                movie2ViewController.title = @"维修结论";
                UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
                actionSheet.title = @"请选择维修结论";
                actionSheet.delegate = self;
                for(NSString *obj in [Share_data sharedShare_data].machine_repairtype)
                {
                    [actionSheet addButtonWithTitle:obj];
                }
                actionSheet.tag = ACTION_TAG_MACHINE_REPAIR_TYPE;
                actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                [actionSheet showInView:self.view];
                [actionSheet release];
                break;
            default:
                break;
        }
    
    }
    else if (MACHINEBOX_BAD_SEND == [Share_data sharedShare_data].ViewType) 
    {
        switch (indexPath.row) {
            case 0:
#if 1                
                // ADD: present a barcode reader that scans from the camera feed
                [self buttonscan];
#else               
                [Share_data sharedShare_data].barcode = @"W.10010";
#endif
                break;
            case 1:
                [Share_data sharedShare_data].sendbuf=@"<option>sendpeopleget</option>\r\n";
                [self sendTCPMsg];
                break;
            default:
                break;
        }
    }
    else if (MACHINEBOX_GOOD_RECV == [Share_data sharedShare_data].ViewType) {
        switch (indexPath.row) {
            case 0:
#if 1                
                // ADD: present a barcode reader that scans from the camera feed
                [self buttonscan];
#else               
                [Share_data sharedShare_data].barcode = @"W.10010";
#endif
                break;
            case 1:
                [Share_data sharedShare_data].sendbuf=@"<option>recvpeopleget</option>\r\n";
                [self sendTCPMsg];
                break;
            default:
                break;
        }
    }

}

- (void)dealloc {
    [imageView release];
    [nameLabel release];
    [decLabel release];
    [super dealloc];
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
    [myAlert dismissWithClickedButtonIndex:0 animated:NO];
    NSString *response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];  
        
    NSLog(@"read data %@ %ld",response,tag);
    //<option>recvpeopleget</option><recvpeople>jdsy-001 jdsy-002</recvpeople>
    if([response rangeOfString:@"barcodeerror"].length >0)
    {
        NSString *AlertInfo = [Share_data mid:response start:@"<result>" end:@"</result>"];
        NSLog(@"%@",AlertInfo);
        [Share_data alertInfo:@"错误提示" msg:AlertInfo];
    }
    else if([response rangeOfString:@"msgsendok"].length >0)
    {
        NSString *AlertInfo = @"工单更新成功";
        NSLog(@"%@",AlertInfo);
        [Share_data alertInfo:@"提示" msg:AlertInfo];
        [Share_data atmcleardate];
    }
    else if([response rangeOfString:@"<machineboxok>"].length >0)
    {
        NSString *AlertInfo = [Share_data mid:response start:@"<machineboxok>" end:@"</machineboxok>"];
        NSLog(@"%@",AlertInfo);
        [Share_data alertInfo:@"提示" msg:AlertInfo];
        [Share_data atmcleardate];
    }
    else if([response rangeOfString:@"sendpeopleget"].length >0)
    {
        [Share_data sharedShare_data].atm_badrecvpeople = [[Share_data mid2:response start:@"<sendpeople>" end:@"</sendpeople>"] componentsSeparatedByString:@" "];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
        actionSheet.title = @"请选择收件人";
        actionSheet.delegate = self;
        for(NSString *obj in [Share_data sharedShare_data].atm_badrecvpeople)
        {
            [actionSheet addButtonWithTitle:obj];
        }
        actionSheet.tag = ACTION_TAG_BAD_RECV_PEOPLE;
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
    else if([response rangeOfString:@"recvpeopleget"].length >0)
    {
        [Share_data sharedShare_data].atm_goodsendpeople = [[Share_data mid2:response start:@"<recvpeople>" end:@"</recvpeople>"] componentsSeparatedByString:@" "];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
        actionSheet.title = @"请选择送件人";
        actionSheet.delegate = self;
        for(NSString *obj in [Share_data sharedShare_data].atm_goodsendpeople)
        {
            [actionSheet addButtonWithTitle:obj];
        }
        actionSheet.tag = ACTION_TAG_GOOD_SEND_PEOPLE;
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
    else if([response rangeOfString:@"machineboxerror"].length >0)
    {
        NSString *AlertInfo = [Share_data mid:response start:@"<machineboxerror>" end:@"</machineboxerror>"];
        NSLog(@"%@",AlertInfo);
        [Share_data alertInfo:@"提示" msg:AlertInfo];
        [Share_data atmcleardate];
    }
    else if([response rangeOfString:@"machineboxrepairinfo"].length >0)
    {
        
        [Share_data sharedShare_data].machine_failjudge = [[Share_data mid2:response start:@"<failjudeg>" end:@"</failjudeg>"] componentsSeparatedByString:@" "];
        [Share_data sharedShare_data].machine_replacenum = [[Share_data mid2:response start:@"<replacenum>" end:@"</replacenum>"] componentsSeparatedByString:@" "];
        [Share_data sharedShare_data].machine_repairtype = [[Share_data mid2:response start:@"<repairtype>" end:@"</repairtype>"] componentsSeparatedByString:@" "];
        [Share_data sharedShare_data].machine_id = [Share_data mid:response start:@"<id>" end:@"</id>"];
    }
    else 
    {
        [Share_data sharedShare_data].atm_serverbank = [Share_data mid:response start:@"<bank>" end:@"</bank>"];
        [Share_data sharedShare_data].atm_net=[Share_data mid:response start:@"<net>" end:@"</net>"];
        [Share_data sharedShare_data].atm_equip_state = [[Share_data mid2:response start:@"<name>" end:@"</name>"] componentsSeparatedByString:@" "];
        [Share_data sharedShare_data].atm_weather = [[Share_data mid2:response start:@"<weather>" end:@"</weather>"] componentsSeparatedByString:@" "];
        [Share_data sharedShare_data].atm_safewarn = [[Share_data mid2:response start:@"<safe>" end:@"</safe>"] componentsSeparatedByString:@" "];		
    }
   
    [response release];
    [sock disconnect];
    [self.tableView reloadData];
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
    
    [myAlert release];
    myAlert = [[yUIAlertViewWithAI alloc]initWithTitle:@"数据传输中" isActiveAI:YES];
    [myAlert show];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    GCDAsyncSocket *mysock = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:mainQueue];
    if (![mysock connectToHost:host onPort:port withTimeout:5.0f error:&error])
    {
        NSLog(@"connected host error %@",error);
    }
    [mysock release];
    
}
// Action sheet delegate method.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case ACTION_TAG_BAD_RECV_PEOPLE:
            // the user clicked one of the OK/Cancel buttons   
            [Share_data sharedShare_data].badrecvpeople = [[Share_data sharedShare_data].atm_badrecvpeople objectAtIndex:buttonIndex];
            break;
        case ACTION_TAG_GOOD_SEND_PEOPLE:
            // the user clicked one of the OK/Cancel buttons   
            [Share_data sharedShare_data].goodsendpeople = [[Share_data sharedShare_data].atm_goodsendpeople objectAtIndex:buttonIndex];
            break;
        case ACTION_TAG_MACHINE_REPAIR_TYPE:
            // the user clicked one of the OK/Cancel buttons   
            [Share_data sharedShare_data].machine_repairtype_select = [[Share_data sharedShare_data].machine_repairtype objectAtIndex:buttonIndex];
            break; 
        case ACTION_TAG_ATM_WEATHER:
            // the user clicked one of the OK/Cancel buttons   
            [Share_data sharedShare_data].selectWeather = [[Share_data sharedShare_data].atm_weather objectAtIndex:buttonIndex];
            break; 
            
        default:
            break;
    }

    [self.tableView reloadData];
}

@end
