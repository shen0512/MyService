//
//  UploadData.h
//  MyService
//
//  Created by Shen on 2022/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadData : NSObject
@property (nonatomic) NSString *path;
@property (nonatomic) NSString *filename;

- (instancetype)init:(NSString *)path :(NSString *)filename;
@end

NS_ASSUME_NONNULL_END
