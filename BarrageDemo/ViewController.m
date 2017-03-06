//
//  ViewController.m
//  BarrageDemo
//
//  Created by cheng on 2017/3/3.
//  Copyright © 2017年 cheng. All rights reserved.
//

#import "ViewController.h"
#import "barrageView.h"
#import "BAImage.h"
#import "BAModle.h"
@interface ViewController ()
/**
 *  弹幕视图
 */
@property (nonatomic, weak) IBOutlet barrageView *danMuview;
/**
 *  弹幕模型数组
 */
@property (nonatomic, strong) NSMutableArray *danMus;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - 获取数据源
- (void)loadData{
    // 获取plist全路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"barrage.plist" ofType:nil];
    // 从指定的路径中加载数据
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    // 遍历数组
    for (NSDictionary *dict in array) {
        // 字典转模型
        BAModle *barrageM = [BAModle barrageWithDict:dict];
        [self.danMus addObject:barrageM];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 获得一个随机整数
    NSInteger index = arc4random_uniform((u_int32_t)self.danMus.count);
    // 获得一个随机模型
    BAModle *danMu = self.danMus[index];
    // 根据模型生成图片
    BAImage *image = [self.danMuview imageWithBarrage:danMu];
    // 调整弹幕加载区域
    image.x = self.view.bounds.size.width;
    image.y = arc4random_uniform(self.danMuview.bounds.size.height - image.size.height);
    // 把图片加到弹幕view上
    [self.danMuview addImage:image];
    
}
#pragma mark - 懒加载
- (NSMutableArray *)danMus{
    if (!_danMus) {
        _danMus = [NSMutableArray new];
    }
    return _danMus;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
