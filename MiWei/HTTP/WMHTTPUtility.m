//
//  WMHTTPUtility.m
//
//

#import "WMHTTPUtility.h"
#import "WMHTTPResult.h"
#import <AFNetworking/AFNetworking.h>

//NSString *const BASE_URL = @"http://60.205.205.82:9998/api/v1/";
NSString *const BASE_URL = @"https://mweb.mivei.com/api/v1/";
//NSString *const WMImagePrefix = @"http://60.205.205.82:9998/api/v1/common/file/";
NSString *const WMImagePrefix = @"https://mweb.mivei.com/api/v1/common/file/";

@implementation WMHTTPUtility
static AFHTTPSessionManager *managerFormEncodeRequest;
static AFHTTPSessionManager *managerJsonRequest;
static dispatch_queue_t wm_http_response_queue;
static WMProfile *myProfile;

+ (AFHTTPSessionManager *)sharedHTTPSessionManagerFormEncodeRequest {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerFormEncodeRequest = [AFHTTPSessionManager manager];
        wm_http_response_queue = dispatch_queue_create("com.miwei.httpRspQueue", DISPATCH_QUEUE_SERIAL);
        managerFormEncodeRequest.completionQueue = wm_http_response_queue;
        managerFormEncodeRequest.requestSerializer = [AFHTTPRequestSerializer serializer];
        [managerFormEncodeRequest.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        managerFormEncodeRequest.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD",  nil];
        managerFormEncodeRequest.requestSerializer.HTTPShouldHandleCookies = YES;
        ((AFJSONResponseSerializer *)managerFormEncodeRequest.responseSerializer).removesKeysWithNullValues = YES;
        managerFormEncodeRequest.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    });
    return managerFormEncodeRequest;
}

+ (AFHTTPSessionManager *)sharedHTTPSessionManagerJsonRequest {
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        managerJsonRequest = [AFHTTPSessionManager manager];
        wm_http_response_queue = dispatch_queue_create("com.miwei.httpRspQueue", DISPATCH_QUEUE_SERIAL);
        managerJsonRequest.completionQueue = wm_http_response_queue;
        managerJsonRequest.requestSerializer = [AFJSONRequestSerializer serializer];
        [managerJsonRequest.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        managerJsonRequest.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD",  nil];
        managerJsonRequest.requestSerializer.HTTPShouldHandleCookies = YES;
        ((AFJSONResponseSerializer *)managerJsonRequest.responseSerializer).removesKeysWithNullValues = YES;
        managerJsonRequest.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    });
    return managerJsonRequest;
}

+ (void)jsonRequestWithHTTPMethod:(WMHTTPRequestMethod)method
                     URLString:(NSString *)URLString
                    parameters:(id)parameters
                      response:(void (^)(WMHTTPResult *))responseBlock {
    AFHTTPSessionManager *session = [WMHTTPUtility sharedHTTPSessionManagerJsonRequest];
    [self requestWithHTTPMethod:method URLString:URLString parameters:parameters session:session response:responseBlock];
}

+ (void)requestWithHTTPMethod:(WMHTTPRequestMethod)method
                    URLString:(NSString *)URLString
                   parameters:(id)parameters
                     response:(void (^)(WMHTTPResult *))responseBlock {
    AFHTTPSessionManager *session = [WMHTTPUtility sharedHTTPSessionManagerFormEncodeRequest];
    [self requestWithHTTPMethod:method URLString:URLString parameters:parameters session:session response:responseBlock];
}

+ (void)requestWithHTTPMethod:(WMHTTPRequestMethod)method
                    URLString:(NSString *)URLString
                   parameters:(id)parameters
                      session:(AFHTTPSessionManager *)session
                     response:(void (^)(WMHTTPResult *))responseBlock {
    NSString *absoluteURLString = [BASE_URL stringByAppendingPathComponent:URLString];
    switch (method) {
        case WMHTTPRequestMethodGet: {
            [session GET:absoluteURLString
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                     if (responseBlock) {
                         responseBlock([self httpSuccessResult:task response:responseObject]);
                     }
                 }
                 failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                     NSLog(@"WMHTTPUtility GET url is %@, error is %@", URLString, error.localizedDescription);
                     if (responseBlock) {
                         responseBlock([self httpFailureResult:task]);
                     }
                 }];
        } break;
        case WMHTTPRequestMethodHead: {
            [session HEAD:URLString
               parameters:parameters
                  success:^(NSURLSessionDataTask *_Nonnull task) {
                      if (responseBlock) {
                          responseBlock([self httpSuccessResult:task response:nil]);
                      }
                  }
                  failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                      NSLog(@"WMHTTPUtility HEAD url is %@, error is %@", URLString, error.localizedDescription);
                      if (responseBlock) {
                          responseBlock([self httpFailureResult:task]);
                      }
                  }];
        } break;
        case WMHTTPRequestMethodPost: {
            [session POST:absoluteURLString
               parameters:parameters
                 progress:nil
                  success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                      if (responseBlock) {
                          responseBlock([self httpSuccessResult:task response:responseObject]);
                      }
                  }
                  failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                      NSLog(@"WMHTTPUtility POST url is %@, error is %@", URLString, error.localizedDescription);
                      if (responseBlock) {
                          responseBlock([self httpFailureResult:task]);
                      }
                  }];
        } break;
        case WMHTTPRequestMethodPut: {
            [session PUT:absoluteURLString
              parameters:parameters
                 success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                     if (responseBlock) {
                         responseBlock([self httpSuccessResult:task response:responseObject]);
                     }
                 }
                 failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                     NSLog(@"WMHTTPUtility PUT url is %@, error is %@", URLString, error.localizedDescription);
                     if (responseBlock) {
                         responseBlock([self httpFailureResult:task]);
                     }
                 }];
        } break;
        case WMHTTPRequestMethodDelete: {
            [session DELETE:absoluteURLString
                 parameters:parameters
                    success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                        if (responseBlock) {
                            responseBlock([self httpSuccessResult:task response:responseObject]);
                        }
                    }
                    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                        NSLog(@"WMHTTPUtility DELETE url is %@, error is %@", URLString, error.localizedDescription);
                        if (responseBlock) {
                            responseBlock([self httpFailureResult:task]);
                        }
                    }];
        } break;
        default:
            break;
    }
}

+ (void)uploadFile:(NSData *)fileData
          response:(void (^)(WMHTTPResult *))responseBlock {
    AFHTTPSessionManager *session = [WMHTTPUtility sharedHTTPSessionManagerFormEncodeRequest];
    
    NSString *absoluteURLString = [BASE_URL stringByAppendingPathComponent:@"/common/file/upload"];
    [session POST:absoluteURLString
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
    [formData appendPartWithFileData:fileData
                                name:@"file"
                            fileName:@"1.jpg"
                            mimeType:@"multipart/form-data"];
}
         progress:nil
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              if (responseBlock) {
                  responseBlock([self httpSuccessResult:task response:responseObject]);
              }
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
              NSLog(@"WMHTTPUtility uploadFile error is %@", error.localizedDescription);
              if (responseBlock) {
                  responseBlock([self httpFailureResult:task]);
              }
          }];
}

+ (NSURL *)urlWithPortraitId:(NSString *)portraitId {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@.jpg", WMImagePrefix, portraitId];
    return [NSURL URLWithString:urlStr];
}

+ (WMHTTPResult *)httpSuccessResult:(NSURLSessionDataTask *)task response:(id)responseObject {
    WMHTTPResult *result = [[WMHTTPResult alloc] init];
    result.httpCode = ((NSHTTPURLResponse *)task.response).statusCode;

    if (!responseObject || [responseObject isKindOfClass:[NSDictionary class]]) {
        result.errorCode = [responseObject[@"errCode"] integerValue];
        result.message = responseObject[@"errMsg"];
        result.content = responseObject[@"data"];
        result.success = (result.errorCode == WMHTTPCodeSuccess);
        if (result.errorCode != WMHTTPCodeSuccess) {
            NSLog(@"http request returns error, url is %@, errorCode is %ld, errMsg is %@, errDetail is %@",
                     ((NSHTTPURLResponse *)task.response).URL, (long)result.errorCode, result.message, responseObject[@"errDetail"]);
        }
    } else {
        result.success = NO;
    }

    return result;
}

+ (WMHTTPResult *)httpFailureResult:(NSURLSessionDataTask *)task {
    WMHTTPResult *result = [[WMHTTPResult alloc] init];
    result.success = NO;
    result.httpCode = ((NSHTTPURLResponse *)task.response).statusCode;
    return result;
}

+ (void)loginWithPhone:(NSString *)phone
                   psw:(NSString *)psw
            wxBindCode:(NSNumber *)wxBindCode
              complete:(void (^)(BOOL))completeBlock {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //4 for iOS APP
    [dic setObject:@(4) forKey:@"loginType"];
    [dic setObject:phone forKey:@"userPhone"];
    [dic setObject:psw forKey:@"userPwd"];
    if (wxBindCode > 0) {
        [dic setObject:wxBindCode forKey:@"wxBindCode"];
    }
    [dic setObject:@(YES) forKey:@"withUserInfo"];
    
    [self requestWithHTTPMethod:WMHTTPRequestMethodPost
                      URLString:@"mobile/user/login"
                     parameters:dic
                       response:^(WMHTTPResult *result) {
                           if (result.success) {
                               NSDictionary *contentDic = result.content;
                               NSString *token = contentDic[@"token"];
                               [self setToken:token];
                               NSDictionary *userInfo = contentDic[@"userInfo"];
                               myProfile = [WMProfile profileWithDic:userInfo];
                               if (completeBlock) {
                                   completeBlock(YES);
                               }
                           } else {
                               NSLog(@"login error, result is %@", result);
                               if (completeBlock) {
                                   completeBlock(NO);
                               }
                           }
                       }];
}

+ (void)loginWithWXOAuthCode:(NSString *)wxOAuthCode
                    complete:(void (^)(WMAuthResult result, NSNumber *wxBindCode))completeBlock {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //4 for iOS APP
    [dic setObject:@(4) forKey:@"loginType"];
    [dic setObject:wxOAuthCode forKey:@"wxOAuthCode"];
    [dic setObject:@(YES) forKey:@"withUserInfo"];
    
    [self requestWithHTTPMethod:WMHTTPRequestMethodPost
                      URLString:@"mobile/user/login"
                     parameters:dic
                       response:^(WMHTTPResult *result) {
                           if (result.success) {
                               NSDictionary *contentDic = result.content;
                               NSString *token = contentDic[@"token"];
                               [self setToken:token];
                               NSDictionary *userInfo = contentDic[@"userInfo"];
                               myProfile = [WMProfile profileWithDic:userInfo];
                               if (completeBlock) {
                                   completeBlock(WMAuthResultSucess, nil);
                               }
                           } else {
                               NSLog(@"login error, result is %@", result);
                               if (result.errorCode == WMHTTPCodeWXNotBind) {
                                   NSDictionary *contentDic = result.content;
                                   NSNumber *wxBindCode = contentDic[@"wxBindCode"];
                                   if (completeBlock) {
                                       completeBlock(WMAuthResultWXNotBind, wxBindCode);
                                   }
                               } else {
                                   completeBlock(WMAuthResultFail, nil);
                               }
                           }
                       }];
}

+ (void)setToken:(NSString *)token {
    NSString *str = [NSString stringWithFormat:@"Bearer %@", token];
    [[WMHTTPUtility sharedHTTPSessionManagerFormEncodeRequest].requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [[WMHTTPUtility sharedHTTPSessionManagerJsonRequest].requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
}

+ (WMProfile *)currentProfile {
    return myProfile;
}

@end
