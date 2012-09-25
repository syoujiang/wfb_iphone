//
//  Share_data.h
//  test3
//
//  Created by jiang ming on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ySingletonImpTemple.h"
#import "yUIAlertViewWithAI.h"

/* server address */
#define HOST @"www.jdsy.org"
//#define HOST @"192.168.1.102"
#define PORT 7070

/* Viewtype*/
enum JDSY_VIEW_TYPE
{
    ATM_CLEAR,
    MACHINEBOX_REPAIR,
    MACHINEBOX_BAD_SEND,
    MACHINEBOX_GOOD_RECV
};

/* LoginType */
enum JDSY_LOGIN_TYPE
{
    LOGIN_NO,
    JDSY_LOGIN,
    BANK_LOGIN
};

/* arrayType */
enum ArrayType
{
    ARRAY_EQUIP,
    ARRAY_WEATHER,
    ARRAY_SAFEWARN,
    ARRAY_FAIL_JUDGE,
    ARRAY_REPAIR_TYPE,
    ARRAY_REPLACE_NUM
};

/*action sheet tag */
enum  {
    ACTION_TAG_BAD_RECV_PEOPLE,
    ACTION_TAG_GOOD_SEND_PEOPLE,
    ACTION_TAG_MACHINE_REPAIR_TYPE,
    ACTION_TAG_ATM_WEATHER,
    ACTION_TAG_END
};
//tag number
#define ATM_CLEAR_SCAN_TAG 10
@interface Share_data : NSObject
{
    NSInteger LoginType;        /* 0:unlogin, 1: login(JDSY) 2:login(bank)*/
    NSInteger ViewType;         /* */
    NSString *barcode;
    NSString *atm_serverbank;   /* 服务银行 */
    NSString *atm_net;          /* 保洁网点 */
    NSArray *atm_equip_state;  /* 设备状态 */
    NSArray *atm_weather;      /* 天气状况 */
    NSArray *atm_safewarn;      /* 安全警告 */
    NSMutableArray *selectStatuesString;
    NSMutableArray *selectSafeString;
    NSString *selectWeather;
    NSString *sendbuf;
    NSInteger arrayType;  
    NSString *Username;
    NSString *badrecvpeople;
    NSString *goodsendpeople;
    NSArray *atm_badrecvpeople;
    NSArray *atm_goodsendpeople;
    
    NSArray *machine_failjudge;
    NSArray *machine_repairtype;
    NSArray *machine_replacenum;
    NSMutableArray *machine_failjudge_select;
    NSString *machine_repairtype_select;
    NSMutableArray *machine_replacenum_select;
    NSString *machine_id;
}
@property (nonatomic, assign) NSInteger arrayType;
@property (nonatomic, assign) NSInteger LoginType;
@property (nonatomic, assign) NSInteger ViewType;
@property (nonatomic, retain) NSString *barcode;
@property (nonatomic, retain) NSString *Username;
@property (nonatomic, retain) NSString *atm_serverbank;
@property (nonatomic, retain) NSString *atm_net;
@property (nonatomic, retain) NSArray *atm_equip_state;
@property (nonatomic, retain) NSArray *atm_weather;
@property (nonatomic, retain) NSArray *atm_safewarn;
@property (nonatomic, retain) NSMutableArray *selectStatuesString;
@property (nonatomic, retain) NSMutableArray *selectSafeString;
@property (nonatomic, retain) NSString *selectWeather;
@property (nonatomic, retain) NSString *sendbuf;
@property (nonatomic, retain) NSString *badrecvpeople;
@property (nonatomic, retain) NSString *goodsendpeople;
@property (nonatomic, retain) NSArray *atm_badrecvpeople;
@property (nonatomic, retain) NSArray *atm_goodsendpeople;

@property (nonatomic, retain) NSArray *machine_failjudge;
@property (nonatomic, retain) NSArray *machine_repairtype;
@property (nonatomic, retain) NSArray *machine_replacenum;
@property (nonatomic, retain) NSMutableArray *machine_failjudge_select;
@property (nonatomic, retain) NSString *machine_repairtype_select;
@property (nonatomic, retain) NSString *machine_id;
@property (nonatomic, retain) NSMutableArray *machine_replacenum_select;

+(NSString *)mid:(NSString *)istr start:(NSString *)str1 end:(NSString *)str2;
+(NSString *)mid2:(NSString *)istr start:(NSString *)str1 end:(NSString *)str2;
+(void)alertInfo:(NSString *)titile msg:(NSString *)alertmsgs;
+(void)atmcleardate;
YLIB_SINGLETON_DEFINE_TEMPLE(Share_data)
@end
