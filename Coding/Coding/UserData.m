//
//  UserData.m
//  Coding
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019 healifeGroup. All rights reserved.
//

#import "UserData.h"
#import <objc/runtime.h>

#define kUSER_DATA_KEY  @"USER_DATA_KEY"

@implementation UserData

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        //归档的key 写的什么 对应属性解档key就写什么
        //self.name = [aDecoder decodeObjectForKey:@"name"];

        unsigned int outCount;
        objc_property_t * properties = class_copyPropertyList([self class], &outCount);
       
        for (int i = 0; i < outCount; i ++) {
            objc_property_t property = properties[i];
            //通过property_getName函数获得属性的名字
            NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            //解档
            id value = [aDecoder decodeObjectForKey:propertyName];
            // 利用KVC赋值
            [self setValue:value forKey:propertyName];
        }
        
        //立即释放properties指向的内存
        free(properties);
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
   
    //归档姓名（NSString 对象）
    //[aCoder encodeObject:self.name forKey:@"name"];

    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
   
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //通过property_getName函数获得属性的名字
        NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id obj = [self valueForKey:propertyName];
        //解档
         [aCoder encodeObject:obj forKey:propertyName];
    }
    
    //立即释放properties指向的内存
    free(properties);
    
}

/**
 支持加密编码 iOS 12
 */
+ (BOOL)supportsSecureCoding{
    return YES;
}


+(void)saveUserDataWithDic:(NSDictionary *)dic{
    if (dic.count == 0) {
        return ;
    }
    
    UserData *user = [[UserData alloc] init];
    //user.name = dic[@"name"];
    
    NSArray *keys = dic.allKeys;
    
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList([UserData class], &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //通过property_getName函数获得属性的名字
        NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        for (NSString *key in keys) {
            if ([key isEqualToString:propertyName]) {
                id obj = dic[key];
                // 利用KVC赋值
                [user setValue:obj forKey:key];
            }
        }
    }
 
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"---- 用户信息归档失败 ----");
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUSER_DATA_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(UserData *)getUserData{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_DATA_KEY];
    NSError *error;
    UserData *user = [NSKeyedUnarchiver unarchivedObjectOfClass:[UserData class] fromData:data error:&error];
    if (error || !data) {
        return nil;
    }
    return user;
}

+ (void)updateUserDataWithUserData:(UserData *)userData{
    
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userData requiringSecureCoding:YES error:&error];
    if (error || !data) {
        NSLog(@"---- 用户信息归档失败 ----");
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUSER_DATA_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+(void)clearUserData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSER_DATA_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
