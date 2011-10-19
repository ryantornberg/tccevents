//
//  DetailWebView.h
//  TccEvents
//
//  Created by Ryan Tornberg on 4/25/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailWebViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *webView;
	NSString *eventDetails;
	NSString *eventName;
	NSString *eventDate;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;	
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *eventDetails;
@property (nonatomic, retain) NSString *eventDate;

//- (NSString *) getFormattedUrl:(NSString *)unformattedUrl;
- (NSString *) fixHtml:(NSString *)unformattedHtml;

@end
