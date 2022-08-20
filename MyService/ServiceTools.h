//
//  ServiceTools.h
//  MyTools
//
//  Created by Shen on 2022/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ServiceTools : NSObject

- (instancetype)init:(BOOL)skipSSL;
- (void)doPostFiles:(NSString*)url :(NSArray*)files progress:(void(^)(NSInteger)) progress completion:(void(^)(NSDictionary*))completion;
@end

NS_ASSUME_NONNULL_END
