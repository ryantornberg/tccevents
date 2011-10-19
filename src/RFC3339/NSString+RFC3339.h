//
//  NSString+RFC3339.h
//  TccEvents
//
//  Created by Ryan Tornberg on 4/27/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RFC3339)

+ (NSString *) stringFromRFC3339Date:(NSDate *)rfc3339Date;
+ (NSString *) stringFromDateYYYYMMDD:(NSDate *)shortDate;
+ (NSString *) timeFromDate:(NSDate *)shortDate;
+ (NSString *) stringFromTodaysDate;

@end
