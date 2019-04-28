//
//  UserData.h
//  Coding
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019 healifeGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserData : NSObject<NSCoding,NSSecureCoding>

///属性不能定义为基本数据类型

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSNumber *age;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,copy) NSString *nickname;


+(void)saveUserDataWithDic:(NSDictionary *)dic;

+(UserData *)getUserData;

+ (void)updateUserDataWithUserData:(UserData *)userData;

+(void)clearUserData;


@end

NS_ASSUME_NONNULL_END
