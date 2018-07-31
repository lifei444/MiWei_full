//
//  WMHTTPUtility.h
//
//

#import "WMHTTPResult.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WMProfile.h"

typedef NS_ENUM(NSUInteger, WMHTTPRequestMethod) {
    WMHTTPRequestMethodGet = 1,
    WMHTTPRequestMethodHead = 2,
    WMHTTPRequestMethodPost = 3,
    WMHTTPRequestMethodPut = 4,
    WMHTTPRequestMethodDelete = 5
};

@interface WMHTTPUtility : NSObject

+ (void)requestWithHTTPMethod:(WMHTTPRequestMethod)method
                    URLString:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                     response:(void (^)(WMHTTPResult *result))responseBlock;

+ (void)uploadFile:(NSData *)fileData
          response:(void (^)(WMHTTPResult *))responseBlock;

+ (NSURL *)urlWithPortraitId:(NSString *)portraitId;

+ (void)loginWithPhone:(NSString *)phone
                   psw:(NSString *)psw
              complete:(void (^)(BOOL))completeBlock;

+ (WMProfile *)currentProfile;
@end
