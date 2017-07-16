//
//  ViewController.m
//  securityDome1
//
//  Created by guogh on 2017/7/15.
//  Copyright © 2017年 郭滚华. All rights reserved.
//

#import "ViewController.h"
#import "codeObfuscation.h"

#import <dlfcn.h>
#import <sys/types.h>


#include <sys/types.h>
#include <sys/sysctl.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

#ifndef PT_DENY_ATTACH
#define PT_DENY_ATTACH 31
#endif

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);


static int is_debugged() __attribute__((always_inline));

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    if (is_debugged() == YES) {
        self.label.text = @"is_debugged ";
        exit(-1);
    }else{
        self.label.text = @"not is_debugged";
    }

}

static int is_debugged(){
    int name[4] = {CTL_KERN,KERN_PROC,KERN_PROC_PID,getpid()};
    struct kinfo_proc Kproc;
    size_t kproc_size = sizeof(Kproc);
    
    memset((void*)&Kproc, 0, kproc_size);
    
    if (sysctl(name, 4, &Kproc, &kproc_size, NULL, 0) == -1) {
        perror("sysctl error \n ");
        exit(-1);
    }
    
    return (Kproc.kp_proc.p_flag & P_TRACED) ? 1 : 0;
}



//以下不需要做任何处理，保持原样即可
-(void)hsk_func1{
    NSLog(@"%@",@"dddddddd");
}

-(void)hsk_func2{
    [self hsk_func1];
}

-(void)hsk_func3{
    [self hsk_func2];
    
    

    
    //    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    //    ptrace_ptr_t ptrace_ptr = (ptrace_ptr_t)dlsym(handle, "ptrace");
    //    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);

    [self hsk_func3];
}



@end
