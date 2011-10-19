//
//  NSDate+RFC3339.h
//
//  Created by Atsushi Nagase on 3/7/11.
//  Copyright 2011 LittleApps Inc. All rights reserved.
// https://gist.github.com/860975


@interface NSDate (RFC3339)

+ (NSDate *) dateFromRFC3339String:(NSString *)rfc3339;
+ (NSDate *) dateFromShortDateString:(NSString *)rfc3339;


@end