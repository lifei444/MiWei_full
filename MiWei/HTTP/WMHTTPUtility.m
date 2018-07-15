//
//  WMHTTPUtility.m
//
//

#import "WMHTTPUtility.h"
#import "WMHTTPResult.h"
#import <AFNetworking/AFNetworking.h>

NSString *const BASE_URL = @"http://60.205.205.82:9998/api/v1/";

@implementation WMHTTPUtility
static AFHTTPSessionManager *manager;
static dispatch_queue_t wm_http_response_queue;

+ (AFHTTPSessionManager *)sharedHTTPSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        wm_http_response_queue = dispatch_queue_create("com.miwei.httpRspQueue", DISPATCH_QUEUE_SERIAL);
        manager.completionQueue = wm_http_response_queue;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    });
    return manager;
}

+ (void)requestWithHTTPMethod:(WMHTTPRequestMethod)method
                    URLString:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                     response:(void (^)(WMHTTPResult *))responseBlock {
    
    
    
    AFHTTPSessionManager *session = [WMHTTPUtility sharedHTTPSession];
    
    NSString *absoluteURLString = [BASE_URL stringByAppendingPathComponent:URLString];
    switch (method) {
        case WMHTTPRequestMethodGet: {
            [session GET:absoluteURLString
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                     [self httpSuccessResult:task response:responseObject];
                 }
                 failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                     NSLog(@"WMHTTPUtility GET url is %@, error is %@", URLString, error.localizedDescription);
                     [self httpFailureResult:task];
                 }];
        } break;
        case WMHTTPRequestMethodHead: {
            [session HEAD:URLString
               parameters:parameters
                  success:^(NSURLSessionDataTask *_Nonnull task) {
                      [self httpSuccessResult:task response:nil];
                  }
                  failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                      NSLog(@"WMHTTPUtility HEAD url is %@, error is %@", URLString, error.localizedDescription);
                      [self httpFailureResult:task];
                  }];
        } break;
        case WMHTTPRequestMethodPost: {
            [session POST:absoluteURLString
               parameters:parameters
                 progress:nil
                  success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                      [self httpSuccessResult:task response:responseObject];
                  }
                  failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                      NSLog(@"WMHTTPUtility POST url is %@, error is %@", URLString, error.localizedDescription);
                      [self httpFailureResult:task];
                  }];
        } break;
        case WMHTTPRequestMethodPut: {
            [session PUT:absoluteURLString
              parameters:parameters
                 success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                     [self httpSuccessResult:task response:responseObject];
                 }
                 failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                     NSLog(@"WMHTTPUtility PUT url is %@, error is %@", URLString, error.localizedDescription);
                     [self httpFailureResult:task];
                 }];
        } break;
        case WMHTTPRequestMethodDelete: {
            [session DELETE:absoluteURLString
                 parameters:parameters
                    success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                        [self httpSuccessResult:task response:responseObject];
                    }
                    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                        NSLog(@"WMHTTPUtility DELETE url is %@, error is %@", URLString, error.localizedDescription);
                        [self httpFailureResult:task];
                    }];
        } break;
        default:
            break;
    }
}

+ (WMHTTPResult *)httpSuccessResult:(NSURLSessionDataTask *)task response:(id)responseObject {
    WMHTTPResult *result = [[WMHTTPResult alloc] init];
    result.httpCode = ((NSHTTPURLResponse *)task.response).statusCode;

    if (!responseObject || [responseObject isKindOfClass:[NSDictionary class]]) {
        result.errorCode = [responseObject[@"code"] integerValue];
        result.message = responseObject[@"msg"];
        result.content = responseObject[@"result"];
        result.success = (result.errorCode == WMHTTPCodeSuccess);
        if (result.errorCode != WMHTTPCodeSuccess) {
            NSLog(@"http request returns error, url is %@, errorCode is %ld",
                     ((NSHTTPURLResponse *)task.response).URL, (long)result.errorCode);
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

@end
