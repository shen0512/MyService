//
//  UploadData.m
//  MyService
//
//  Created by Shen on 2022/8/20.
//

#import "UploadData.h"

@implementation UploadData

- (instancetype)init:(NSString *)path :(NSString *)filename{
    self = [super init];
    
    self.path = path;
    self.filename = filename;
    
    return self;
}

@end
