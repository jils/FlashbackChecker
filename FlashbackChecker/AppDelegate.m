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
            NSString *format = NSLocalizedString(@"Potential Issue found at: %@", @"Message displayed in the results section in case an issue is found; the %@ string is a placeholder for the file path, that should be left in place");
            [self log:[NSString stringWithFormat:format, theFile]];
            [self log:[theObject description]];
            theInfected = YES;
        }
        else 
        {
            NSString* thePath = [theFile stringByExpandingTildeInPath];
            if( [[NSFileManager defaultManager] fileExistsAtPath:thePath] )
            {
                NSString *format = NSLocalizedString(@"Clear: %@", @"Message displayed in the results section in case no issue is found in the scanned file; the %@ string is a placeholder for the file path, that should be left in place");
                [self log:[NSString stringWithFormat:format, thePath]];
            }
            else
            {
                NSString *format = NSLocalizedString(@"Clear (no file found): %@", @"Message displayed in the results section in case no issue is found because there is no corresponding file; the %@ string is a placeholder for the file path, that should be left in place");
                [self log:[NSString stringWithFormat:format, thePath]];
            }
        }
    }
    
    if( !theInfected )
    {
        [self log:NSLocalizedString(@"No Signs of infection were found.", @"Message displayed in the results section at the end of the scan if no issue was found")];
    }
    
    NSString* theVisit = NSLocalizedString(@"\n\nVisit the F-Secure site for more information:\nhttp://www.f-secure.com/v-descs/trojan-downloader_osx_flashback_i.shtml", @"Message displayed at the end of the scan to get visit a site with more information");
    [self log:theVisit];
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
