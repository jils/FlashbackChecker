//
//  AppDelegate.m
//  FlashBackChecker
//
//  Created by Juan Leon on 4/5/12.
//  Copyright (c) 2012 NotOptimal.net. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate (Private)

- (id)valueForKey:(NSString*)aKey atPath:(NSString*)aPath;
- (void)log:(NSString*)aString;

@end


@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

- (IBAction)checkForInfection:(id)aSender
{
    [textView setString:@""];
        
    
    NSString* theSafari = @"/Applications/Safari.app/Contents/Info.plist";
    NSString* theFirefox = @"/Applications/Firefox.app/Contents/Info.plist";
    NSString* theEnvironment = @"~/.MacOSX/environment.plist";
        
    NSArray* theFiles = [NSArray arrayWithObjects:theSafari, theFirefox, theEnvironment, nil];
    BOOL theInfected = NO;
    for( NSString* theFile in theFiles )
    {   
        NSString* theKey = @"LSEnvironment";
        if( [theFile isEqualToString:theEnvironment] )
        {
            theKey = @"DYLD_INSERT_LIBRARIES";
        }
        
        id theObject = [self valueForKey:theKey atPath:theFile];
        if( theObject )
        {
            [self log:[NSString stringWithFormat:@"Potential Issue found at: %@", theFile]];
            [self log:[theObject description]];
            theInfected = YES;
        }
        else 
        {
            NSString* thePath = [theFile stringByExpandingTildeInPath];
            if( [[NSFileManager defaultManager] fileExistsAtPath:thePath] )
            {
                [self log:[NSString stringWithFormat:@"Clear: %@", thePath]];
            }
            else
            {
                [self log:[NSString stringWithFormat:@"Clear (no file found): %@", thePath]];
            }
        }
    }
    
    if( !theInfected )
    {
        [self log:@"No Signs of infection were found."];
    }
    
    NSString* theVisit = @"\n\nVisit the F-Secure site for more information:";
    [self log:theVisit];

    // There must be a simpler way to do this, right?
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"http://www.f-secure.com/v-descs/trojan-downloader_osx_flashback_i.shtml"];
    NSRange range = NSMakeRange(0, [attrString length]);
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[[NSURL URLWithString:@"http://www.f-secure.com/v-descs/trojan-downloader_osx_flashback_i.shtml"] absoluteString] range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    [attrString addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
    [attrString endEditing];
    
    [[textView textStorage] appendAttributedString:attrString];
    [attrString autorelease];
}


@end



@implementation AppDelegate (Private)

- (id)valueForKey:(NSString*)aKey atPath:(NSString*)aPath
{
    id theReturn = nil;
    
    NSString* thePath = [aPath stringByExpandingTildeInPath];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:thePath] )
    {
        NSDictionary* theDict = [NSDictionary dictionaryWithContentsOfFile:thePath];
        theReturn = [theDict objectForKey:aKey];
    }
    return theReturn;
}

- (void)log:(NSString*)aString
{
    NSString* theString = [textView string];
    [textView setString:[NSString stringWithFormat:@"%@%@\n", theString, aString]];
}



@end
