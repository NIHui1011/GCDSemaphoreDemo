//
//  HHUploadImageManager.h
//  happyfamily
//
//  Created by 倪辉辉 on 2016/9/27.
//  Copyright © 2016年 xf1jr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SuccessBlock)(NSString *imgUrlStr);
typedef void(^FailureBlock)(NSString *error);
typedef void(^UploadSuccessBlock)(NSArray <NSString *>*imgUrlStrs);
typedef void(^UploadFailureBlock)(NSArray <NSString *>*imgUrlStrs,NSString *error);

@interface HHUploadImageManager : NSObject
+ (HHUploadImageManager *)shareManager;
- (void)uploadImageToAliWithObjectKey:(NSString *)objectkey
                         withImage:(UIImage *)img
                     withSuccessBlock:(SuccessBlock)successBlock
                     withFailureBlock:(FailureBlock)failureBlock;
- (void)uploadImagesWithArray:(NSArray *)imgs
                withObjectKey:(NSString *)objectKey
               withLimitedNum:(NSInteger)num
             withSuccessBlock:(UploadSuccessBlock)successBlock
             withFailureBlock:(UploadFailureBlock)failureBlock;
- (void)myUploadImagesWithArray:(NSArray *)imgs
                  withObjectKey:(NSString *)objectKey
                 withLimitedNum:(NSInteger)num
               withSuccessBlock:(UploadSuccessBlock)successBlock
               withFailureBlock:(UploadFailureBlock)failureBlock;
@end
