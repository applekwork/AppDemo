//
//  MyTool.m
//  XNSudai
//
//  Created by zxl on 2017/3/24.
//  Copyright © 2017年 xulu. All rights reserved.
//

#import "MyTool.h"
#import <AdSupport/AdSupport.h>

@implementation MyTool

+ (void)removeValueforKey:(NSString *)str{
    if ([MyTool readValueForKey:str]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:str];
    }
}

+ (void)writeValue:(id)value forKey:(NSString *)str{
    [[NSUserDefaults standardUserDefaults]  setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:str];
}

+ (id)readValueForKey:(NSString *)str{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:str];
    if (!obj) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:obj];
}

+ (NSString *)idfa{
    NSString *idfaStr;
    Class theClass=NSClassFromString(@"ASIdentifierManager");
    if (theClass)
    {
        idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }else{
        idfaStr = @"";
    }
    return idfaStr;
}

/**
 *
 *  此方法用于显示提示信息
 *  @param alertStr 提示信息
 *
 */
+ (void)showAlertView:(NSString*)alertStr
{
    if (!alertStr) {
        return;
    }
    UIAlertView *tempAltView = [[UIAlertView  alloc]initWithTitle:@"" message:alertStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil ];
    [tempAltView show];
}

+ (NSString *)getStringFromObj:(id)obj{
    return obj?[NSString stringWithFormat:@"%@",obj]:@"";
}

/**
 *
 *  此方法用于显示提示信息
 *  @param object 传入的json
 *  @return 转换后的字符串
 *
 */
+ (NSString *)jsonStrFromObj:(id)object
{
    if (!object) {
        return @"";
    }
    NSString *jsonString = @"";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        DLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
+ (UIFont *)regularFontWithSize:(CGFloat)size{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}
//处理图片的方向信息
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIFont *)lightFontWithSize:(CGFloat)size{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (void)arrayImageWithName:(NSString* )imageName block:(void(^)(NSArray* images))imgBlock
{
    dispatch_queue_t queue = dispatch_queue_create("handle_gif_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        CGFloat scale = [UIScreen mainScreen].scale;
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (scale > 1.0f) {
            path = [[NSBundle mainBundle] pathForResource:[imageName stringByAppendingString:@"@2x"] ofType:@"gif"];
            data = [NSData dataWithContentsOfFile:path];
        }
        if(!data){
            imgBlock(nil);
            return;
        }
        
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        size_t count = CGImageSourceGetCount(source);
        NSMutableArray *images = [NSMutableArray array];
        for (size_t i = 0; i < count; i++) {
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
            CGSize sz = CGSizeMake(CGImageGetWidth(imageRef)/scale, CGImageGetHeight(imageRef)/scale);
            
            UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            CGContextTranslateCTM(ctx, 0, sz.height);
            CGContextScaleCTM(ctx, 1, -1);
            CGRect rect = CGRectMake(0, 0, sz.width, sz.height);
            CGContextDrawImage(ctx, rect, imageRef);
            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            CGContextRestoreGState(ctx);
            UIGraphicsEndImageContext();
            
            [images addObject:image];
            CGImageRelease(imageRef);
        }
        CFRelease(source);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imgBlock(images);
        });
    });
}
@end
