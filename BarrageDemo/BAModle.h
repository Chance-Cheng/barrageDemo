//
//  BAModle.h
//  BarrageDemo
//
//  Created by cheng on 2017/3/3.
//  Copyright © 2017年 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAModle : NSObject
/**
 *  表情数组
 */
@property (nonatomic, strong) NSArray *emotions;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;
/**
 *  用户输入内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  弹幕类型 YES:自己发的   NO:别人发的
 */
@property (nonatomic, assign) BOOL type;
/**
 *  字典转模型
 */
+ (instancetype)barrageWithDict:(NSDictionary *)dict;

@end
