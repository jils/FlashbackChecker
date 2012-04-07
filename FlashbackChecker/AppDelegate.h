//
//  AppDelegate.h
//  FlashBackChecker
//
//  Created by Juan Leon on 4/5/12.
//  Copyright (c) 2012 NotOptimal.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject //<NSApplicationDelegate>
{
    IBOutlet NSWindow* window;
    IBOutlet NSTextView* textView;
}

- (IBAction)checkForInfection:(id)aSender;

@end
