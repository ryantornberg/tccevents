//
//  SeatingChartWebViewController.h
//  TccEvents
//
//  Created by Ryan Tornberg on 5/13/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SeatingChartWebViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *webView;
	NSString *seatingChartDetails;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;


@end
