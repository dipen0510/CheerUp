//
//  SharedClass.h
//  PampersRewards
//
//  Created by Dipen Sekhsaria on 03/11/15.
//  Copyright © 2015 ProcterAndGamble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedClass : NSObject <DataSyncManagerDelegate> {

}

+ sharedInstance;

-(NSDate *)getCurrentUTCFormatDate;
-(NSString* )getCurrentUTCFormatDateString;

- (void)saveBookmarkData: (NSString*)data;
- (NSString*)loadBookmarkDataForService;
- (void)removeBookmarkServiceData;
- (NSMutableDictionary *) getDictionaryFromJSONString:(NSString *)jsonString;

- (void) startPostGCMService;

@end
