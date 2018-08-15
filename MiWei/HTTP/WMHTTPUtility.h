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

typedef NS_ENUM(NSUInteger, WMAuthResult) {
    WMAuthResultSucess = 1,
    WMAuthResultFail = 2,
    WMAuthResultWXNotBind = 3
};

@interface WMHTTPUtility : NSObject

+ (void)requestWithHTTPMethod:(WMHTTPRequestMethod)method
                    URLString:(NSString *)URLString
                   parameters:(id)parameters
                     response:(void (^)(WMHTTPResult *result))responseBlock;

//json
+ (void)jsonRequestWithHTTPMethod:(WMHTTPRequestMethod)method
                    URLString:(NSString *)URLString
                   parameters:(id)parameters
                     response:(void (^)(WMHTTPResult *result))responseBlock;

+ (void)uploadFile:(NSData *)fileData
          response:(void (^)(WMHTTPResult *))responseBlock;

+ (NSURL *)urlWithPortraitId:(NSString *)portraitId;

+ (void)loginWithPhone:(NSString *)phone
                   psw:(NSString *)psw
            wxBindCode:(NSNumber *)wxBindCode
              complete:(void (^)(BOOL))completeBlock;

+ (void)loginWithWXOAuthCode:(NSString *)wxOAuthCode
                    complete:(void (^)(WMAuthResult result, NSNumber *wxBindCode))completeBlock;

+ (WMProfile *)currentProfile;
@end
