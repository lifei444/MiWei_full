//
//  WMHTTPResult.h
//
//

#import <Foundation/Foundation.h>

@interface WMHTTPResult : NSObject

typedef NS_ENUM(NSInteger, WMHTTPErrorCode) {
    
    /**
     * 未知错误。
     */
    WMHTTPCodeUNKNOWN = -1,// "unknown"
    
    WMHTTPCodeSuccess = 0,
    
    //微信未绑定米微账号
    WMHTTPCodeWXNotBind = 0x020d,
    
    //无效微信授权码
    WMHTTPCodeInvalidWXOAuthCode = 0x020e,
    
    
    
};

//请求是否成功
@property(nonatomic, assign) BOOL success;

// http错误码
@property(nonatomic, assign) NSInteger httpCode;

//接口状态码，必选
@property(nonatomic, assign) NSInteger errorCode;

//接口结果描述，不一定返回
@property(nonatomic, strong) NSString *message;

// json，成功才返回
@property(nonatomic, strong) id content;

@end
