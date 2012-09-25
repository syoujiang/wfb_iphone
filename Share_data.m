//
//  Share_data.m
//  test3
//
//  Created by jiang ming on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Share_data.h"
#import "ySingletonImpTemple.h"

@implementation Share_data
@synthesize ViewType;
@synthesize LoginType;

@synthesize barcode;
@synthesize atm_serverbank;
@synthesize atm_net;
@synthesize atm_equip_state;
@synthesize atm_weather;
@synthesize sendbuf;
@synthesize atm_safewarn;
@synthesize arrayType;
@synthesize Username;
@synthesize selectWeather;
@synthesize selectSafeString;
@synthesize selectStatuesString;
@synthesize goodsendpeople;
@synthesize badrecvpeople;
@synthesize atm_badrecvpeople;
@synthesize atm_goodsendpeople;

@synthesize machine_failjudge;
@synthesize machine_repairtype;
@synthesize machine_replacenum;
@synthesize machine_failjudge_select;
@synthesize machine_repairtype_select;
@synthesize machine_replacenum_select;
@synthesize machine_id;

YLIB_SINGLETON_IMP_TEMPLE(Share_data);
+(void)alertInfo:(NSString *)titile msg:(NSString *)alertmsgs
{
    UIAlertView *InfoAlert = [[UIAlertView alloc]initWithTitle:titile
                                                       message:alertmsgs 
                                                      delegate:self 
                                             cancelButtonTitle:@"确定" 
                                             otherButtonTitles:nil];
    InfoAlert.tag=10;
    [InfoAlert show];
    [InfoAlert release];
}
+(NSString *)mid:(NSString *)istr start:(NSString *)str1 end:(NSString *)str2
{
    //<option>recvpeopleget</option><recvpeople>jdsy-001 jdsy-002</recvpeople>
    NSLog(@"%@",istr);
    NSRange rangestart =[istr rangeOfString:str1];
    NSRange rangeend =[istr rangeOfString:str2];
    NSString *temp = [istr substringToIndex:rangeend.location]; 
    NSLog(@"%@",temp);
    NSString *recvp = [temp substringFromIndex:rangestart.location+[str1 length]];
    NSLog(@"%d", [str1 length]);
    NSLog(@"%@",recvp);
    return recvp;
}
+(NSString *)mid2:(NSString *)istr start:(NSString *)str1 end:(NSString *)str2
{
    //<safe>正常 安全门故障 大厅门故障 大厅广告字符损坏 天花板缺失 天花板漏水 空调漏水 语音模块故障 其他 </safe>
    NSLog(@"%@",istr);
    NSRange rangestart =[istr rangeOfString:str1];
    NSRange rangeend =[istr rangeOfString:str2];
    NSString *temp = [istr substringToIndex:rangeend.location]; 
    NSLog(@"%@",temp);
    NSString *recvp = [temp substringFromIndex:rangestart.location+[str1 length]];
    NSLog(@"%d", [str1 length]);
    NSString *recvp2 = [recvp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"%@",recvp2);
    return recvp2;
}
+(void)atmcleardate
{
    [Share_data sharedShare_data].barcode = nil;
    [Share_data sharedShare_data].barcode=nil;
    [Share_data sharedShare_data].atm_serverbank=nil;   /* 服务银行 */
    [Share_data sharedShare_data].atm_net= nil;          /* 保洁网点 */
    [Share_data sharedShare_data].atm_equip_state = nil;  /* 设备状态 */
    [Share_data sharedShare_data].atm_weather = nil;      /* 天气状况 */
    [Share_data sharedShare_data].atm_safewarn=nil;      /* 安全警告 */
    [Share_data sharedShare_data].selectStatuesString=nil;
    [Share_data sharedShare_data].selectSafeString=nil;
    [Share_data sharedShare_data].selectWeather=nil;
    [Share_data sharedShare_data].sendbuf=nil;
 //   [Share_data sharedShare_data].machine_failjudge;
 //   [Share_data sharedShare_data].machine_repairtype;
 //   [Share_data sharedShare_data].machine_replacenum;
 //   [Share_data sharedShare_data].machine_failjudge_select;
 //   [Share_data sharedShare_data].machine_repairtype_select;
 //   [Share_data sharedShare_data].machine_replacenum_select;
  //  [Share_data sharedShare_data].machine_id;

}
@end
