//
//  User.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/2.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    UserVerifiedTypeNone = -1,
    UserVerifiedTypePersonal = 0,
    UserVerifiedTypeOrgEnterprice = 2,
    UserVerifiedTypeOrgMedia = 3,
    UserVerifiedTypeOrgWebsite = 5,
    UserVerifiedTypeDaren = 220
} UserVerifiedType;

@interface User : NSObject
/** 字符串型的用户UID  */
@property (copy, nonatomic) NSString *idstr;
/** 友好显示名称 */
@property (copy, nonatomic) NSString *name;
/** 用户头像地址（中图），50×50像素 */
@property (copy, nonatomic) NSString *profile_image_url;

/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;
@property (nonatomic, assign, getter = isVip) BOOL vip;

@property (assign, nonatomic) UserVerifiedType verified_type;

@end
