//
//  WMHTTPResult.m
//
//

#import "WMHTTPResult.h"

@implementation WMHTTPResult

- (NSString *)description {
    return [NSString stringWithFormat:@"success: %d, httpCode: %ld, errorCode: %ld, message: %@, content: %@",
            self.success, (long)self.httpCode, (long)self.errorCode, self.message, self.content];
}

@end
