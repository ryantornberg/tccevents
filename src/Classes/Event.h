//
//  Event.h
//  TccEvents
//
//  Created by Ryan Tornberg on 4/29/11.
//  Copyright (c) 2011 City of Tucson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSDate *timeStamp;

@property (nonatomic, retain) NSDate *primitiveTimeStamp;
@property (nonatomic, retain) NSString *primitiveSectionIdentifier;


@end
