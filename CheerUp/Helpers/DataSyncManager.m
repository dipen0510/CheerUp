//
//  DataSyncManager.m
//  PampersRewards
//
//  Created by Dipen Sekhsaria on 15/11/15.
//  Copyright (c) 2015 ProcterAndGamble. All rights reserved.
//

#import "DataSyncManager.h"


@implementation DataSyncManager
@synthesize delegate,serviceKey;



-(void)startPOSTWebServicesWithParams:(NSMutableDictionary *)postData
{
    
    NSURL* url;
    url = [NSURL URLWithString:DomainBaseURL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    

    [manager POST:self.serviceKey parameters:postData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        
    } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        //if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([[responseObject valueForKey:@"status"] intValue] == 1 || [[responseObject valueForKey:@"result"] intValue] == 1) {
                
                if ([delegate respondsToSelector:@selector(didFinishServiceWithSuccess:andServiceKey:)]) {
                    [delegate didFinishServiceWithSuccess:[self prepareResponseObjectForServiceKey:self.serviceKey withData:responseObject] andServiceKey:self.serviceKey];
                }
            }
            else {
            //if ([delegate respondsToSelector:@selector(didFinishServiceWithFailure:)]) {
                [delegate didFinishServiceWithFailure:[responseObject valueForKey:@"msg"]];
            //}
            
            }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if ([delegate respondsToSelector:@selector(didFinishServiceWithFailure:)]) {
           [delegate didFinishServiceWithFailure:NSLocalizedString(@"Verify your internet connection and try again", nil)];
        }
        
        
    }];
    
    
}



-(void)startGETWebServices
{
    
    NSURL* url;
    url = [NSURL URLWithString:DomainBaseURL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager GET:self.serviceKey parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([delegate respondsToSelector:@selector(didFinishServiceWithSuccess:andServiceKey:)]) {
                [delegate didFinishServiceWithSuccess:[self prepareResponseObjectForServiceKey:self.serviceKey withData:responseObject] andServiceKey:self.serviceKey];
            }
        }
        else {
            //if ([delegate respondsToSelector:@selector(didFinishServiceWithFailure:)]) {
            [delegate didFinishServiceWithFailure:[responseObject valueForKey:@"msg"]];
            //}
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if ([delegate respondsToSelector:@selector(didFinishServiceWithFailure:)]) {
            [delegate didFinishServiceWithFailure:NSLocalizedString(@"Verify your internet connection and try again", nil)];
        }
        
        
    }];
    
    
}

- (id) prepareResponseObjectForServiceKey:(NSString *) responseServiceKey withData:(id)responseObj {
    
    return responseObj;
    
}





- (NSString *) errorStringForService:(NSString *) responseServiceKey withData:(id)responseObj {
    
//    if ([responseServiceKey isEqualToString:kLoginService]) {
//        
//        if ([[responseObj valueForKey:@"code"] isEqualToString:USERNAME_EMPTYKey]) {
//            
//            return NSLocalizedString(@"Please enter your email", nil);
//            
//        }
//        else if ([[responseObj valueForKey:@"code"] isEqualToString:PASSWORD_EMPTYKey]) {
//            
//            return NSLocalizedString(@"Please enter a password", nil);
//            
//        }
//        else if ([[responseObj valueForKey:@"code"] isEqualToString:USER_NOT_FOUND_LEGKey] || [[responseObj valueForKey:@"code"] isEqualToString:USER_NOT_FOUND_PCKey]) {
//            
//            return NSLocalizedString(@"The email and password combination you entered is incorrect. Please try again.", nil);
//            
//        }
//        
//    }
//    
//    if ([responseServiceKey isEqualToString:kImageUploadService]) {
//        
//        if ([[responseObj valueForKey:@"message"] isEqualToString:cappingLimitReachedKey]) {
//            
//            return NSLocalizedString(@"Sorry! Your receipt processing limit has been reached. Please send again tomorrow.", nil);
//            
//        }
//        
//    }
//    
//    if ([responseServiceKey isEqualToString:kRegisterService]) {
//    
//        NSString *correctString = [NSString stringWithCString:[[responseObj valueForKey:@"message"] cStringUsingEncoding:NSUTF8StringEncoding]
//                                                     encoding:NSNonLossyASCIIStringEncoding];
//        
//        correctString = [[correctString componentsSeparatedByString:@": "] lastObject];
//        correctString = [correctString stringByReplacingOccurrencesOfString:@"\"]" withString:@""];
//        
//       return correctString;
//            
//    }
    
    
    return NSLocalizedString(@"An issue occured while processing your request. Please try again later.", nil);
    
}




@end
