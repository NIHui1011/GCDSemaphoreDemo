//
//  HHUploadImageManager.m
//  happyfamily
//
//  Created by 倪辉辉 on 2016/9/27.
//  Copyright © 2016年 xf1jr. All rights reserved.
//

#import "HHUploadImageManager.h"



@implementation HHUploadImageManager
static HHUploadImageManager * manager;
+ (HHUploadImageManager *)shareManager{
    if (manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[HHUploadImageManager alloc] init];
        });
        return manager;
    }
    return manager;
}
- (void)uploadImageToAliWithObjectKey:(NSString *)objectkey
                         withImage:(UIImage *)img
                     withSuccessBlock:(SuccessBlock)successBlock
                     withFailureBlock:(FailureBlock)failureBlock{
    if([img isKindOfClass:[UIImage class]]){
        NSData *imgData;
        imgData = UIImagePNGRepresentation(img);//压缩体积
        if (imgData.length > 1024000) {//图片不大于1M
            CGSize imgSize = CGSizeMake(img.size.width / 2, img.size.height / 2);
            imgData = [self zipImage:img scaledToSize:imgSize];//压缩图片尺寸
        }
        successBlock([NSString stringWithFormat:@"%@ :success",objectkey]);
    }else{
        failureBlock([NSString stringWithFormat:@"%@ :faliure",objectkey]);
    }
}
- (void)uploadImagesWithArray:(NSArray *)imgs
                withObjectKey:(NSString *)objectKey
               withLimitedNum:(NSInteger)num
             withSuccessBlock:(UploadSuccessBlock)successBlock
             withFailureBlock:(UploadFailureBlock)failureBlock{
    if (!imgs ) {
        failureBlock(nil,@"图片数组为空");
    }
    if (!objectKey) {
        failureBlock(nil,@"上传路径为空");
    }
    NSInteger limitedNum = 0;
    if (!num) {
        limitedNum = imgs.count;
    }else{
        limitedNum = imgs.count>num?num:imgs.count;
    }
//    NSMutableArray *imgUrlArray = [NSMutableArray new];
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("标示符", DISPATCH_QUEUE_SERIAL);
    //异步
//    dispatch_async(queue, ^{
//        for (NSInteger i=0; i < limitedNum; i++) {
//            if ([imgs[i] isKindOfClass:[NSString class]]) {
//            }else{
//            }
//            //增加信号量
//            dispatch_semaphore_signal(semaphore);
//            [self uploadImageToAliWithObjectKey:objectKey withFileData:imgs[i] withSuccessBlock:^(NSString *imgUrlStr) {
//                NSLog(@"%ld : %@ success" ,i,imgUrlStr);
//                //减少信号量
//                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//            } withFailureBlock:^(NSString *imgUrlStr) {
//                NSLog(@"%ld : %@ falure" ,i,imgUrlStr);
//                
//            }];
//        }
//    });
    
    for (NSInteger i=0; i < limitedNum; i++) {
        if ([imgs[i] isKindOfClass:[NSString class]]) {
        }else{
        }
        //增加信号量
        dispatch_async(queue, ^{
            
            dispatch_semaphore_signal(semaphore);
            [self uploadImageToAliWithObjectKey:objectKey withImage:imgs[i] withSuccessBlock:^(NSString *imgUrlStr) {
                NSLog(@"%ld : %@ success" ,i,imgUrlStr);
                //减少信号量
//                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            } withFailureBlock:^(NSString *imgUrlStr) {
                NSLog(@"%ld : %@ falure" ,i,imgUrlStr);
                
            }];
            NSLog(@"finish0");
        });
        
        NSLog(@"finish1");
    }
    
    NSLog(@"finish2");
    
    
    
}


- (void)myUploadImagesWithArray:(NSArray *)imgs
                  withObjectKey:(NSString *)objectKey
                 withLimitedNum:(NSInteger)num
               withSuccessBlock:(UploadSuccessBlock)successBlock
               withFailureBlock:(UploadFailureBlock)failureBlock{
    if (!imgs ) {
        failureBlock(nil,@"图片数组为空");
        return;
    }
    if (!objectKey) {
        failureBlock(nil,@"上传路径为空");
        return;
    }
    NSInteger limitedNum = 0;
    if (!num) {
        limitedNum = imgs.count;
    }else{
        limitedNum = imgs.count>num?num:imgs.count;
    }
    static BOOL hhHavUploadError = NO;
    static NSMutableArray *hhUploadSuccessArray;
    static NSMutableArray *hhUploadFaliureArray;
    hhUploadSuccessArray = [NSMutableArray new];
    hhUploadFaliureArray = [NSMutableArray new];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("标示符", DISPATCH_QUEUE_SERIAL);
    for (NSInteger i=0; i < limitedNum; i++) {

        dispatch_async(queue, ^{
            
            dispatch_group_enter(group);
            [self uploadImageToAliWithObjectKey:objectKey withImage:imgs[i] withSuccessBlock:^(NSString *imgUrlStr) {
                NSLog(@"%ld : %@ success" ,i,imgUrlStr);
                [hhUploadSuccessArray addObject:imgUrlStr];
                
                dispatch_group_leave(group);
                
            } withFailureBlock:^(NSString *imgUrlStr) {
                NSLog(@"%ld : %@ falure" ,i,imgUrlStr);
// [NSString stringWithFormat:@"第%ld张图上传出错",i];
                hhHavUploadError = YES;
                [hhUploadFaliureArray addObject:imgUrlStr];
                dispatch_group_leave(group);
            }];
        });
    }

    dispatch_group_notify(group, queue, ^{
        //任务都完成回调
        NSLog(@"allfinish");
        successBlock(hhUploadSuccessArray);
        if (hhHavUploadError) {
            failureBlock(hhUploadFaliureArray,nil);
        }
    });
/*
 进入dispatch_group_enter和退出dispatch_group_leave次数必须匹配
 */

}

//图片处理，图片压缩
- (NSData *)zipImage:(UIImage*)image
        scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}
@end
