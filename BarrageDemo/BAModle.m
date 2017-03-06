//
//  BAModle.m
//  BarrageDemo
//
//  Created by cheng on 2017/3/3.
//  Copyright © 2017年 cheng. All rights reserved.
//

#import "BAModle.h"

@implementation BAModle
+ (instancetype)barrageWithDict:(NSDictionary *)dict{
    // 字典转模型
    id obj = [[self alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}
@end
