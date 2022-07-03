//
//  ServiceTools.m
//  MyTools
//
//  Created by Shen on 2022/7/2.
//

#import "ServiceTools.h"

@interface ServiceTools()<NSURLSessionDelegate>
@property (nonatomic) BOOL skipSSL;
@end

@implementation ServiceTools

- (instancetype)init:(BOOL)skipSSL{
    self = [super init];
    
    self.skipSSL = skipSSL;
    
    return self;
}

- (void)doPost:(NSString*)url :(NSString*)param :(NSDictionary*)jsonBody{
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBody options:kNilOptions error:nil];

    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";

    [request setURL:[NSURL URLWithString:[url stringByAppendingPathComponent:param]]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonBodyData];
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSHTTPURLResponse *asHTTPResponse = (NSHTTPURLResponse *) response;
        NSLog(@"The response is: %@", asHTTPResponse);

        NSDictionary *forJSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@", forJSONObject);
        
        if([self.delegate respondsToSelector:@selector(getPostResult::)]){
            [self.delegate getPostResult:asHTTPResponse :forJSONObject];
        }
        
    }];
    [task resume];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    
    if(self.skipSSL){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }else{
        
    }
}
@end
