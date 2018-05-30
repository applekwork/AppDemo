//
//  NSObject+XN.m
//  XNManager
//
//  Created by Allen on 2017/5/5.
//  Copyright © 2017年 Carlson Lee. All rights reserved.
//

#import "NSObject+XN.h"

@implementation NSObject (XN)

+(NSString *)XNClassName{
    const char *className=class_getName(self);
    return [NSString stringWithUTF8String:className];
    
}

@end
