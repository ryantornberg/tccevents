//
//  ParkingMapWebViewController.h
//  TccEvents
//
//  Created by Ryan Tornberg on 5/10/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ParkingMapWebViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *webView;
	NSString *parkingMapDetails;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
