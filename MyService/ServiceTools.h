//
//  ServiceTools.h
//  MyTools
//
//  Created by Shen on 2022/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ServiceToolsDelegate <NSObject>
-(void) getProgress:(NSInteger)progress;
@end
@interface ServiceTools : NSObject
@property (nonatomic) id <ServiceToolsDelegate> delegate;

- (instancetype)init:(BOOL)skipSSL;
- (NSDictionary*)doPostFiles:(NSString*)url :(NSString*)param :(NSString*)fileRoot :(NSArray*)files;
@end

NS_ASSUME_NONNULL_END
