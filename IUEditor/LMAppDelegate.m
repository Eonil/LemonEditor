//
//  LMAppDelegate.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMAppDelegate.h"
#import "LMWC.h"
#import "JDLogUtil.h"
#import "LMStartWC.h"

#import "IUDjangoProject.h"
#import "IUWordpressProject.h"

#import "LMPreferenceWC.h"
#import "IUProjectController.h"
#import "LMNotiManager.h"
#import "JDEnvUtil.h"
#import "LMTutorialWC.h"
#import "LMHelpWC.h"

@implementation LMAppDelegate{
    LMStartWC *startWC;
    LMPreferenceWC *preferenceWC;
    LMNotiManager *notiManager;
    LMTutorialWC *tutorialWC;
}

+ (void)initialize{
    //user default setting
    NSString *defaultsFilename = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
    // initialize a dictionary with contents of it
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:defaultsFilename];
    // register the stuff
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
#if DEBUG
    if ([JDEnvUtil isFirstExecution:@"IUEditor"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://server.iueditor.org/download.php"]];
        [NSURLConnection connectionWithRequest:request delegate:nil];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://server.iueditor.org/use.php"]];
    [NSURLConnection connectionWithRequest:request delegate:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];

#else
    
    //if there is no opend document,
    if([[[NSDocumentController sharedDocumentController] documents] count] < 1){
        [self showStartWC:self];
    }
    
    notiManager = [[LMNotiManager alloc] init];
    [notiManager connectWithServerAfterDelay:0];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"iututorial"] == NO) {
        tutorialWC = [[LMTutorialWC alloc] initWithWindowNibName:@"LMTutorialWC"];
        [tutorialWC showWindow:self];
    }
    
#endif
    /*
    [JDLogUtil showLogLevel:YES andFileName:YES andFunctionName:YES andLineNumber:YES];
    [JDLogUtil setGlobalLevel:JDLog_Level_Debug];
    [JDLogUtil enableLogSection:IULogSource];
    [JDLogUtil enableLogSection:IULogJS];
    [JDLogUtil enableLogSection:IULogAction];
//    [JDLogUtil enableLogSection:IULogText];
    

*/
    [JDLogUtil enableLogSection:IULogDealloc];

    [JDLogUtil setGlobalLevel:JDLog_Level_Error];

}


- (IBAction)showStartWC:(id)sender{
    startWC = [LMStartWC sharedStartWindow];
    [startWC showWindow:self];
}


- (IBAction)openPreference:(id)sender {
     preferenceWC = [[LMPreferenceWC alloc] initWithWindowNibName:@"LMPreferenceWC"];
    [preferenceWC showWindow:self];
}



- (IBAction)performHelp:(NSMenuItem *)sender{
    LMHelpWC *hWC = [LMHelpWC sharedHelpWC];
    if (sender.tag == 0) {
        [hWC showHelpWebURL:[NSURL URLWithString:@"http://jdlaborg.github.io/LemonEditor/"] withTitle:@"About Project"];
    }
    else {
        switch (sender.tag) {
            case 1:
                [hWC showHelpDocumentWithKey:@"RunningAProject"];
                break;
            case 2:
                [hWC showHelpDocumentWithKey:@"tracing"];
                break;
            case 3:
                [hWC showHelpDocumentWithKey:@"positionProperty"];
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - application delegate

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender{
    return NO;
}


- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    if(flag == NO) {
#if DEBUG
        
        //open last document
        NSArray *recents = [[NSDocumentController sharedDocumentController] recentDocumentURLs];
        if ([recents count]){
            NSURL *lastURL = [recents objectAtIndex:0];
            [(IUProjectController *)[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:lastURL display:YES completionHandler:nil];
            
            
        }
#else
        //cmd + N 화면
        //https://developer.apple.com/library/mac/documentation/cocoa/reference/NSApplicationDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/NSApplicationDelegate/applicationOpenUntitledFile:
        
        [self showStartWC:self];
        
#endif
        return NO;
    }
    return YES;
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename{
    if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
        NSURL *url = [NSURL fileURLWithPath:filename];
        [(IUProjectController *)[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url display:YES completionHandler:nil];
        return YES;
    }
    return NO;
}

- (IBAction)newWP:(id)sender {
}

@end