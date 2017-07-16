//
//  ViewController.m
//  ggh函数混淆
//
//  Created by guogh on 2017/7/16.
//  Copyright © 2017年 郭滚华. All rights reserved.
//

#import "ViewController.h"
#import "codeObfuscation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ggh_func1];
}


-(void)ggh_func1{
    [self ggh_func2];
}

-(void)ggh_func2{
    [self ggh_func3];
}

-(void)ggh_func3{
    [self ggh_func4];
}

-(void)ggh_func4{
    NSLog(@"hello world！");
}

@end
