//
//  ViewController.m
//  GCDSemaphoreDemo
//
//  Created by 倪辉辉 on 2016/9/27.
//  Copyright © 2016年 倪辉辉. All rights reserved.
//

#import "ViewController.h"
#import "HHUploadImageManager.h"
@interface ViewController ()
{
    NSMutableArray *_imgs;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    [[HHUploadImageManager shareManager] uploadImagesWithArray:@[@"pic1",@"pic2",@"pic3",@"pic4",@"pic5",@"pic6"] withObjectKey:@"http://hh.com" withLimitedNum:5 withSuccessBlock:^(NSArray<NSString *> *imgUrlStrs) {
//        
//    } withFailureBlock:^(NSString *error) {
//        
//    }];
    
//    [[HHUploadImageManager shareManager] myUploadImagesWithArray:@[@"pic1",@"pic2",@"pic3",[NSNumber numberWithInteger:4],@"pic5",@"pic6"] withObjectKey:@"http://hh.com" withLimitedNum:5 withSuccessBlock:^(NSArray<NSString *> *imgUrlStrs) {
//        NSLog(@"mainFinish");
//        
//    } withFailureBlock:^(NSArray<NSString *> *imgUrlStrs,NSString *error) {
//        NSLog(@"mainFailure");
//    }];
    
    
}

- (IBAction)click:(UIButton *)sender {
    _imgs = [NSMutableArray new];
    for (NSInteger i=0; i<11; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",i+1]];
        [_imgs addObject:img];
    }
    [[HHUploadImageManager shareManager] myUploadImagesWithArray:_imgs withObjectKey:@"http://hh.com" withLimitedNum:100 withSuccessBlock:^(NSArray<NSString *> *imgUrlStrs) {
        NSLog(@"mainFinish");
        NSLog(@"%@",imgUrlStrs);
    } withFailureBlock:^(NSArray<NSString *> *imgUrlStrs,NSString *error) {
        NSLog(@"mainFailure");
        NSLog(@"%@",imgUrlStrs);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
