//
//  WMQRCode.m
//  SinQRCodeKit
//
//  Created by Sin on 17/1/12.
//  Copyright © 2017年 Sin. All rights reserved.
//

#import "WMQRCode.h"
#import "WMQRCodeGenerator.h"
#import "WMQRCodeScanner.h"


@interface WMQRCode ()<WMQRCodeScanResultDelegate>

@end

@implementation WMQRCode
+ (instancetype)sharedWMQRCode {
  static WMQRCode *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc]init];
  });
  return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [WMQRCodeScanner sharedWMQRCodeScanner].delegate = self;
    }
    return self;
}

- (UIImage *)generateQRCodeWithContent:(NSString *)content {
  return [WMQRCodeGenerator generateQRCodeWithContent:content];
}

- (UIImage *)generateInnerImageQRCodeWithContent:(NSString *)content innerImage:(UIImage *)innerImage scale:(CGFloat)scale {
  return [WMQRCodeGenerator generateInnerImageQRCodeWithContent:content innerImage:innerImage scale:scale];
}


- (void)scanQRCodeFromImage:(UIImage *)image {
    WMQRCodeScanner *scanner = [WMQRCodeScanner sharedWMQRCodeScanner];
    [scanner scanQRCodeFromCurrentImage:image];
}

- (void)scanQRCideWithCamera:(UIView *)scanView rectOfInterest:(CGRect)frame {
    [[WMQRCodeScanner sharedWMQRCodeScanner] scanQRCideWithCamera:scanView rectOfInterest:frame];
}

- (void)stopScanAndRemoveViews {
    [[WMQRCodeScanner sharedWMQRCodeScanner] stopScanAndRemoveViews];
}

- (void)scanQRCodeWithAlbum:(UIViewController *)currentVC {
    [[WMQRCodeScanner sharedWMQRCodeScanner] scanQRCodeWithAlbum:currentVC];
}

#pragma mark WMQRCodeScanResultDelegate
- (void)scanner:(WMQRCodeScanner *)scanner didScanOutResult:(NSArray<NSString *> *)results {
  if(self.scannerDelegate && [self.scannerDelegate respondsToSelector:@selector(scanQRCode:didScanOutResult:)]) {
    [self.scannerDelegate scanQRCode:self didScanOutResult:results];
  }
}

@end
