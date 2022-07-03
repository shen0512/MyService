//
//  ServiceTools.h
//  MyTools
//
//  Created by Shen on 2022/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ServiceToolsDelegate <NSObject>
@optional
- (void)getPostResult:(NSHTTPURLResponse*) response :(NSDictionary*)data;

@end
@interface ServiceTools : NSObject
@property (nonatomic) id <ServiceToolsDelegate> delegate;

- (instancetype)init:(BOOL)skipSSL;
- (void)doPost:(NSString*)url :(NSString*)param :(NSDictionary*)jsonBody;

@end

NS_ASSUME_NONNULL_END
