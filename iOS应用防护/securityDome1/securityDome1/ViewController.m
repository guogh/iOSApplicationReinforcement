//
//  ViewController.m
//  securityDome1
//
//  Created by guogh on 2017/7/15.
//  Copyright © 2017年 郭滚华. All rights reserved.
//

#import "ViewController.h"

#define STRING_OBFUSCATE

static char* decryptConstString(char* string) __attribute__((always_inline));

#define NSSTRING(string) [NSString stringWithUTF8String:decryptConstString(string)]
#define CSTRING(string) decryptConstString(string)

static char* decryptConstString(char* string)
{
    char* origin_string = string;
    while(*string) {
        *string ^= 0xAA;
        string++;
    }
    return origin_string;
}

#ifndef STRING_OBFUSCATE

#define NSSTRING(string) @string
#define CSTRING(string) string

#endif


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

#define lableText1 NSSTRING(((char []) {194, 207, 198, 198, 197, 139, 0}));

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    static NSString *labeText3 = @"welcome";

    self.label1.text = lableText1;
    self.label2.text = NSSTRING(((char []) {226, 207, 198, 198, 197, 134, 138, 221, 197, 216, 198, 206, 139, 0}));
    self.label3.text = labeText3;

    printf("%s",CSTRING(((char []) {221, 207, 198, 201, 197, 199, 207, 138, 226, 207, 198, 198, 197, 134, 138, 221, 197, 216, 198, 206, 139, 0})));
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
