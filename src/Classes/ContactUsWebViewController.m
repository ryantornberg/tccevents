//
//  ContactUsWebViewController.m
//  TccEvents
//
//  Created by Ryan Tornberg on 5/10/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import "ContactUsWebViewController.h"

@implementation ContactUsWebViewController

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[webView release];
	[contactUsDetails release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	self.view = webView;
	self.webView.delegate = self;
	self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
	self.webView.scalesPageToFit = YES;
	self.navigationItem.title = @"TCC Contacts";
	NSString *myHtml = @"<html><head><title>TCC Contacts</title><meta content='width=device-width; initial-scale=1.0; maximum-scale=3.0; user-scalable=1;' name='viewport' /></head><body><h2>Tucson Convention Center</h2><p><strong>Phone</strong>: <a href='tel:1-520-837-4762'>(520) 837-4762</a><br /><a href='http://maps.google.com/maps?q=260+South+Church+Avenue+Tucson+AZ'>260 South Church Avenue<br />Tucson, Arizona 85701</a></p><h2>Meetings, Conventions&nbsp;&amp; Event Managment</h2><p>Kate Breck Calhoun<br />Sales and Marketing Director<br /><strong>Phone:</strong>(520) 837-4757<br /><a href='mailto:kate.calhoun@tucsonaz.gov'>kate.calhoun@tucsonaz.gov</a></p><p>&nbsp;</p><h2><strong>Weddings, Quincea&ntilde;eras &amp; Receptions</strong></h2><p>Lauren Grimes<br />Event Coordinator Intern<br /><strong>Phone</strong>: (520) 837-4762<br /><a href='mailto:tccint1.tccint1@tucsonaz.gov'>tccint1.tccint1@tucsonaz.gov</a></p><p><br />Metropolitan Tucson Convention and Visitors Bureau<br /><a href='http://www.visittucson.org'>www.visittucson.org</a><br /><a href='tel:1-800-288-2766'>1-888-2TUCSON</a></p><p>&nbsp;</p><h2>Concerts &amp; Event Management</h2><p>Tommy Obermaier<br />Deputy Director<br /><strong>Phone:</strong> (520) 837-4760<br /><a href='mailto:tommy.obermaier@tucsonaz.gov'>tommy.obermaier@tucsonaz.gov</a></p><p>&nbsp;</p><h2>Catering, Weddings &amp; Receptions</h2><p>Jennifer Pendley<br />Sales Manager<br /><strong>Phone:</strong> (520) 882-9820<br /><a href='mailto:pittinger-emily@aramark.com'>pendley-jennifer@aramark.com</a></p><p>&nbsp;</p><h2>Contracts &amp; Permits</h2><p>Janis Ward<br />Secretary, Contracts and Permits<br /><strong>Phone:</strong> (520) 837-4759<br /><a href='mailto:janis.ward@tucsonaz.gov'>janis.ward@tucsonaz.gov</a></p><p>&nbsp;</p><h2>Ticketing</h2><p>Martin Carey<br />Ticket Office Manager<br /><strong>Phone:</strong> (520) 837-4765<br /><a href='mailto:martin.carey@tucsonaz.gov'>martin.carey@tucsonaz.gov</a></p><p>Pat Cole<br />Ticket Office Supervisor<br /><strong>Phone:</strong> (520)&nbsp;837-4766<br /><a href='mailto:pat.cole@tucsonaz.gov'>pat.cole@tucsonaz.gov</a></p><p>Donna Miller<br />Ticket Office Supervisor<br /><strong>Phone:</strong> (520)&nbsp;837-4767<br /><a href='mailto:donna.miller@tucsonaz.gov'>donna.miller@tucsonaz.gov</a></p><p>&nbsp;</p><h2>Parking</h2><p>William Ricketts<br />Parking Manager<br /><strong>Phone:</strong> (520) 837-4777<br /><a href='mailto:william.ricketts@tucsonaz.gov'>william.ricketts@tucsonaz.gov</a></p><p>&nbsp;</p><h2>Technical Staff</h2><p>David Darland<br />Event Services Manager<br /><strong>Phone:</strong> (520) 837-4750<br /><a href='mailto:david.darland@tucsonaz.gov'>david.darland@tucsonaz.gov</a></p><p>&nbsp;</p><h2>Administration Office</h2><p>Richard Singer<br />Director<br /><strong>Phone:</strong> (520)&nbsp;837-4749<br /><a href='mailto:richard.singer@tucsonaz.gov'>richard.singer@tucsonaz.gov</a></p><p>Elizabeth O&#39;Hara-Walker<br />Administrator<br /><strong>Phone:</strong> (520) 837-4775<br /><a href='mailto:elizabeth.o'hara-walker@tucsonaz.gov'>elizabeth.o&#39;hara-walker@tucsonaz.gov</a></p><p>&nbsp;</p><h2>Electric Contractor</h2><p>Jennifer Sutherland</p><p>Account Manager<br />Commonwealth Electric Company<br />Exposition Services Division<br /><a href='http://maps.google.com/maps?q=260+South+Church+Avenue+Tucson+AZ'>260 South Church Avenue<br />Tucson, AZ. 85701</a></p><p><strong>Phone</strong> (520)623-2155<br /><strong>Fax</strong> (520)623-3401<br /><a href='mailto:JSutherland@commonwealthelectic.com'>JSutherland@commonwealthelectic.com</a></p><p>&nbsp;</p><h2>Mobile App Email Support</h2><p><a href='mailto:mobileapps@tucsonaz.gov'>mobileapps@tucsonaz.gov</a></p></body></html>";
	[self.webView loadHTMLString:myHtml baseURL:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.webView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == YES);
	return YES;
}


//- (BOOL) webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//		NSURL *url = [request URL];
//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url absoluteString]]];
//		return NO;
//	}
//	return YES;
//}



@end
