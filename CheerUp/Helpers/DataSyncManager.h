//
//  DataSyncManager.h
//  PampersRewards
//
//  Created by Dipen Sekhsaria on 15/11/15.
//  Copyright (c) 2015 ProcterAndGamble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AFNetworking.h>

@protocol DataSyncManagerDelegate <NSObject>

-(void) didFinishServiceWithSuccess:(id)responseData andServiceKey:(NSString *)requestServiceKey;
-(void) didFinishServiceWithFailure:(NSString *)errorMsg;

@optional


@end

@interface DataSyncManager : NSObject

@property (nonatomic,assign)  id <DataSyncManagerDelegate> delegate;
@property (nonatomic, strong) NSString* serviceKey;


-(void)startPOSTWebServicesWithParams:(NSMutableDictionary *)postData;
-(void)startGETWebServices;

@end
