//
//  SharedClass.m
//  PampersRewards
//
//  Created by Dipen Sekhsaria on 03/11/15.
//  Copyright © 2015 ProcterAndGamble. All rights reserved.
//

#import "SharedClass.h"

@implementation SharedClass

static SharedClass *singletonObject = nil;

+ (id)sharedInstance {
    //static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
    });
    return singletonObject;
}



- (id)init
{
    if (! singletonObject) {
        
        singletonObject = [super init];
        // Uncomment the following line to see how many times is the init method of the class is called
        // //NSLog(@"%s", __PRETTY_FUNCTION__);
    }
    return singletonObject;
}

#pragma mark - Calendar helpers

-(NSDate* )getCurrentUTCFormatDate
{
    
    NSDate* localDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    NSDate* utcDate = [dateFormatter dateFromString:dateString];
    
    return utcDate;
}

-(NSString* )getCurrentUTCFormatDateString
{
    
    NSDate* localDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    return dateString;
}


#pragma mark - Local Storage Handling

- (void)saveData: (NSString*)data ForService:(NSString *)service
{
    if (data != nil)
    {
        
        [self removeServiceData:service];
        
        NSString *documentsDirectory = [self getDocumentDirectoryPath];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.txt",service] ];
        
        [data writeToFile:path atomically:YES
                 encoding:NSUTF8StringEncoding error:nil];
    }
}

- (NSString*)loadDataForService:(NSString *)service
{
    NSString *documentsDirectory = [self getDocumentDirectoryPath];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@.txt",service] ];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    return content;
}

- (void)removeServiceData:(NSString *)service
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [self getDocumentDirectoryPath];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@.txt",service] ];
    
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:path error:&error];
    if (success) {
        NSLog(@"Successfully Removed %@",[error localizedDescription]);
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}


- (NSString *) getDocumentDirectoryPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
    
}

- (NSMutableDictionary *) getDictionaryFromJSONString:(NSString *)jsonString {
    
    NSError* e;
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    
    return dict;
    
}


- (void) startPostGCMService {
    
    NSMutableDictionary* reqDict = [self prepareDictForPostGCMService];
    
    if (reqDict) {
        DataSyncManager* manager = [[DataSyncManager alloc] init];
        manager.serviceKey = kPostGCM;
        manager.delegate = self;
        [manager startPOSTWebServicesWithParams:reqDict];
    }
    
    
}


#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(id)responseData andServiceKey:(NSString *)requestServiceKey {
    
    if ([requestServiceKey isEqualToString:kPostGCM]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsGCMPosted];
        
    }
    
}


- (void) didFinishServiceWithFailure:(NSString *)errorMsg {
    
    [SVProgressHUD dismiss];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:@"An issue occured while processing your request. Please try again later."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    [alert addAction:noButton];
    
    
    if (![errorMsg isEqualToString:@""]) {
        [alert setMessage:errorMsg];
    }
    
    if ([errorMsg isEqualToString:NSLocalizedString(@"Verify your internet connection and try again", nil)]) {
        [alert setTitle:NSLocalizedString(@"Connection unsuccessful", nil)];
    }
    
    return;
    
}

- (NSMutableDictionary *) prepareDictForPostGCMService {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]) {
        [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken] forKey:@"GCM_ID"];
    }
    else {
//        [dict setObject:@"1234" forKey:@"GCM_ID"];
        return nil;
    }
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kCurrentCity] forKey:@"CITY"];
    [dict setObject:@"2" forKey:@"DEVICE_TYPE"];
    
    return dict;
    
}

@end
