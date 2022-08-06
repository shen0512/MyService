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

- (void)doPostImg:(NSString*)url :(NSString*)param :(NSString*)msg :(NSData*)data :(NSString*)filename{
    NSString *boundary = @"boundary";
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=msg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: text/plain\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=files; filename=%@.jpg\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";

    [request setURL:[NSURL URLWithString:[url stringByAppendingPathComponent:param]]];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:nil];
    
    __block NSDictionary *jsonObject;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSHTTPURLResponse *asHTTPResponse = (NSHTTPURLResponse *) response;
        NSLog(@"The response is: %@", asHTTPResponse);

        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
        if([self.delegate respondsToSelector:@selector(getPostResult::)]){
            [self.delegate getPostResult:asHTTPResponse :jsonObject];
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

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    NSInteger percentage = (double)totalBytesSent * 100 / (double)totalBytesExpectedToSend;
    NSLog(@"Upload %ld%% ",(long)percentage);
    if([self.delegate respondsToSelector:@selector(getProgress:)]){
        [self.delegate getProgress: percentage];
    }
    
    
}
@end
