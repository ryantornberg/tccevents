//
//  Event.m
//  TccEvents
//
//  Created by Ryan Tornberg on 4/29/11.
//  Copyright (c) 2011 City of Tucson. All rights reserved.
//

#import "Event.h"
#import "NSString+RFC3339.h"


@implementation Event
@dynamic title;
@dynamic details;
@dynamic timeStamp;
@dynamic primitiveTimeStamp;
@dynamic primitiveSectionIdentifier;


#pragma mark -
#pragma mark Transient properties


#pragma mark -
#pragma mark Time stamp setter

- (void)setTimeStamp:(NSDate *)newDate {
    
    // If the time stamp changes, the section identifier become invalid.
    [self willChangeValueForKey:@"timeStamp"];
    [self setPrimitiveTimeStamp:newDate];
    [self didChangeValueForKey:@"timeStamp"];
    
    [self setPrimitiveSectionIdentifier:nil];
}


#pragma mark -
#pragma mark Key path dependencies


+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier {
	// if the value of startDate changes, the section identifier may change as well
	return [NSSet setWithObject:@"timeStamp"];
}

@end
