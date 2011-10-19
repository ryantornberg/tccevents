//
//  NSString+RFC3339.m
//  TccEvents
//
//  Created by Ryan Tornberg on 4/27/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import "NSString+RFC3339.h"
#import "NSDate+RFC3339.h"
#import "GDataDateTime.h"

@implementation NSString (RFC3339)


+ (NSString *) stringFromDateYYYYMMDD:(NSDate *)shortDate 
{
//	NSLocale *locale = [NSLocale currentLocale];
//	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease]; 
//	NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:locale];
//	[formatter setDateFormat:dateFormat];
//	[formatter setLocale:locale];
//	NSString *dateString = [[NSString alloc] initWithString: [formatter stringFromDate:shortDate]];
//	[dateString autorelease];
//	return dateString;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *formattedDateString = [dateFormatter stringFromDate:shortDate];
//	NSLog(@"stringFromDateYYYYMMDD: %@", formattedDateString);
    [dateFormatter release];
	return formattedDateString;
}


+ (NSString *) stringFromTodaysDate {

	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	components.day = 0;
	NSDate *tomorrow = [gregorian dateByAddingComponents:components toDate:today options:0];
	[components release];
	
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	components = [gregorian components:unitFlags fromDate:tomorrow];
	components.hour = 0;
	components.minute = 0;
	
	NSDate *todayMidnight = [gregorian dateFromComponents:components];
	
	[gregorian release];
	
	GDataDateTime *gdataDateTime = [GDataDateTime dateTimeWithDate:todayMidnight
														  timeZone:[NSTimeZone systemTimeZone]];
	
	NSString *formattedDateString = [gdataDateTime RFC3339String];
	return formattedDateString;
}

+ (NSString *) stringFromRFC3339Date:(NSDate *)rfc3339Date {
	NSLocale *locale = [NSLocale currentLocale];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease]; 
	NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E MMM d yyyy" options:0 locale:locale];
	[formatter setDateFormat:dateFormat];
	[formatter setLocale:locale];
	NSString *formattedDate = [formatter stringFromDate:rfc3339Date];
	if(formattedDate == nil) {
		formattedDate = (NSString *)rfc3339Date;
	}
//	if(formattedDate == nil) {
//		NSLog(@"stringFromRFC3339Date: %@", rfc3339Date);
//	}
	NSString *dateString = [[NSString alloc] initWithString:formattedDate];
    [dateString autorelease];
	return dateString;
}


+ (NSString *) timeFromDate:(NSDate *)shortDate {
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"hh:mm a"];
	NSString *time = [timeFormat stringFromDate:shortDate];
	[timeFormat release];
	return time;
}


@end
