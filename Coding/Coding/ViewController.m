//
//  ViewController.m
//  Coding
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019 healifeGroup. All rights reserved.
//

#import "ViewController.h"

#import "UserData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1.是否接收推送通知开关 处理逻辑
    UISwitch *switchBar = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    [switchBar addTarget:self action:@selector(switchBarAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchBar];
    
    BOOL isUnRegister = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_KEY"] boolValue];
    switchBar.on = isUnRegister;
    
    
    //2.APP个人用户信息保存
    NSDictionary *dic = @{@"name" :@"FxiaoBinaa",
                          @"age" :@(28),
                          @"userId" :@"000109",
                          @"sex" :@"男",
                          @"nickname" :@"小鲁班"
                          };
    
    [UserData saveUserDataWithDic:dic];
     
     UserData *user = [UserData getUserData];
     
     NSLog(@"--- name = %@, age = %@, userId = %@, sex = %@, nickname = %@ ----",user.name, user.age, user.userId,user.sex, user.nickname);
   
    
    user.name = @"哈哈哈哈";
    user.nickname = @"达摩神犬";
    user.sex = @"保密";
    [UserData updateUserDataWithUserData:user];
    
    UserData *user1 = [UserData getUserData];
    
    NSLog(@"--- name = %@, age = %@, userId = %@, sex = %@, nickname = %@ ----",user1.name, user1.age, user1.userId,user1.sex, user1.nickname);
    
}


-(void)switchBarAction:(UISwitch *)sv{
    
    BOOL isOn = sv.isOn;
    if (isOn) { //打开 - 不接收消息
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }else{  //关闭 - 接收消息
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOn] forKey:@"Notification_KEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
