//
//  TccEventsAppDelegate.h
//  TccEvents
//
//  Created by Ryan Tornberg on 3/8/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TccEventsAppDelegate : NSObject <UIApplicationDelegate> {
	
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
    UIWindow *window;
    UINavigationController *navigationController;

}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;


- (NSString *)applicationDocumentsDirectory;

@end

