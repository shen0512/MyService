//
//  ServiceTools.h
//  MyTools
//
//  Created by Shen on 2022/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^getP)(NSInteger pr);

@protocol ServiceToolsDelegate <NSObject>
-(void) getProgress:(NSInteger)progress;
@end
@interface ServiceTools : NSObject
@property (nonatomic) id <ServiceToolsDelegate> delegate;

- (instancetype)init:(BOOL)skipSSL;
- (void)doPostFiles:(NSString*)url :(NSString*)fileRoot :(NSArray*)files completion:(void(^)(NSDictionary*))completion;
- (void)doPostFiles2:(NSString*)url :(NSString*)fileRoot :(NSArray*)files completion:(void(^)(NSDictionary*))completion;
@end

NS_ASSUME_NONNULL_END
