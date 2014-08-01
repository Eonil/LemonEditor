//
//  LMHerokuWC.m
//  IUEditor
//
//  Created by jd on 2014. 7. 29..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMHerokuWC.h"
#import "JDHerokuUtil.h"
#import "JDGitUtil.h"
#import "JDDateTimeUtil.h"

@interface LMHerokuWC  () <JDHerokuUtilLoginDelegate, JDGitUtilDelegate>
@property NSString *herokuID;
@property NSString *password;
@property NSString *appName;
@property BOOL     isGitRepo;
@property NSString *gitRepoStatus;
@property (weak) IBOutlet NSButton *gitInitB;
@property (weak) IBOutlet NSTextField *herokuAppNameTF;
@property (weak) IBOutlet NSTextField *herokuAppNameLabel;
@property (unsafe_unretained) IBOutlet NSTextView *herokuTV;
@property (weak) IBOutlet NSButton *herokuVisitB;

@property (weak) IBOutlet NSTextField *passwordLabel;
@property (weak) IBOutlet NSTextField *passwordTF;
@property (weak) IBOutlet NSButton *herokuLoginB;
@property (weak) IBOutlet NSTextField *herokuIDTF;
@property (weak) IBOutlet NSTextField *herokuIDLabel;
@property NSString *herokuApp;
@property (weak) IBOutlet NSButton *herokuAppB;
@property BOOL showHerokuAppInfo;

@property BOOL herokuLogined;
@property NSString *herokuLoginLog;
@end

@implementation LMHerokuWC  {
    JDHerokuUtil *herokuUtil;
    JDGitUtil   *gitUtil;
    NSString *_gitRepoPath;
    BOOL windowLoaded;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        herokuUtil = [[JDHerokuUtil alloc] init];
//        self.herokuLogMessage = [NSMutableString string];
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // check heroku login
    [self refreshGitUI];
    [self setShowHerokuLoginInfo];
    [self setShowHerokuAppInfo];
    windowLoaded = YES;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)sync:(id)sender{
    //create configru
    [herokuUtil prepareHerokuUpload:_gitRepoPath];
    
    [gitUtil addAll];
    NSString *commitMessage = [JDDateTimeUtil stringForDate:[NSDate date] option:JDDateStringTimestampType];
    [gitUtil commit:commitMessage];
    [gitUtil push:@"heroku" branch:@"master" force:YES];
}

- (IBAction)login:(id)sender {
    herokuUtil.loginDelegate = self;
    [herokuUtil login:self.herokuID password:self.password];
}

-(void)herokuUtil:(JDHerokuUtil*)util loginProcessFinishedWithResultCode:(NSInteger)resultCode{
    if (resultCode == 1) {
        //login failed
        self.herokuLoginLog = @"Login Failed";
    }
    else {
        self.herokuLoginLog = @"Login Success";
        [self setShowHerokuLoginInfo];
        [self setShowHerokuAppInfo];
    }
}

- (IBAction)herokuInit:(id)sender {
    //heroku create app
    NSString *resultLog;
    BOOL result = [herokuUtil create:self.appName resultLog:&resultLog];
    if (result) {
        //YES
        //combine git
        [herokuUtil combineGitPath:self.gitRepoPath appName:self.appName];
        [JDUIUtil hudAlert:@"App created. Press Sync." second:2];
        [self addHerokuLog:@"App created. Press Sync."];
        [self setShowHerokuAppInfo];
    }
    else {
        //Failed
        [JDUIUtil hudAlert:resultLog second:2];
    }
}

- (IBAction)gitInit:(id)sender{
    JDGitUtil *util = [[JDGitUtil alloc] initWithGitRepoPath:_gitRepoPath];
    BOOL result = [util gitInit];
    if (result) {
        self.isGitRepo = YES;
        [self.gitInitB setHidden:YES];
        [self refreshGitUI];
        [self showHerokuAppInfo];
    }
}

- (void)refreshGitUI{
    if (self.isGitRepo) {
        self.gitRepoStatus = @"Git Status OK";
        [self.gitInitB setHidden:YES];
    }
    else {
        self.gitRepoStatus = @"Not Set : Need to be initialized";
        [self.gitInitB setHidden:NO];
    }
}

- (void)setGitRepoPath:(NSString *)path{
    _gitRepoPath = [path copy];
    gitUtil = [[JDGitUtil alloc] initWithGitRepoPath:_gitRepoPath];
    gitUtil.delegate = self;
    if ([[NSFileManager defaultManager] fileExistsAtPath:_gitRepoPath isDirectory:NO] == NO) {
        self.isGitRepo = NO;
        self.gitRepoStatus = @"No directory Existed. Please build first.";
    }
    else {
        self.isGitRepo = [gitUtil isGitRepo];
        [self refreshGitUI];
    }
    [self setShowHerokuLoginInfo];
    [self setShowHerokuAppInfo];
}

- (void)setShowHerokuAppInfo{
    if (self.herokuLogined && self.isGitRepo) {
        self.showHerokuAppInfo = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (windowLoaded) {
                [self addHerokuLog:[JDHerokuUtil configMessageForPath:self.gitRepoPath]];
                [self addHerokuLog:@"\n"];
            }
            self.herokuApp = [JDHerokuUtil herokuAppNameAtPath:self.gitRepoPath];
            
            if (self.herokuApp) {
                [self.herokuAppNameTF setHidden:YES];
                [self.herokuAppNameLabel setHidden:NO];
                [self.herokuAppB setHidden:YES];
                [self.herokuVisitB setHidden:NO];
            }
            else {
                [self.herokuAppNameTF setHidden:NO];
                [self.herokuAppNameLabel setHidden:YES];
                [self.herokuAppB setHidden:NO];
                [self.herokuVisitB setHidden:YES];
            }
        });
    }
    else {
        self.showHerokuAppInfo = NO;
    }
}
    
- (IBAction)performHerokuVisit:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"http://%@.herokuapp.com", self.herokuApp];
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)setShowHerokuLoginInfo{
    self.herokuID = [JDHerokuUtil loginID];
    if (self.herokuID) {
        self.herokuLogined = YES;
        [_herokuIDLabel setHidden:NO];
        [_herokuIDTF setHidden:YES];
        [_herokuLoginB setHidden:YES];
        [_passwordTF setHidden:YES];
        [_passwordLabel setHidden:YES];
    }
    else {
        self.herokuLogined = NO;
        [_herokuIDLabel setHidden:YES];
        [_herokuIDTF setHidden:NO];
        [_herokuLoginB setHidden:NO];
        [_passwordTF setHidden:NO];
        [_passwordLabel setHidden:NO];
    }
}

- (NSString*)gitRepoPath{
    return _gitRepoPath;
}

- (IBAction)pressCancel:(id)sender {
    [self.window.sheetParent endSheet:self.window];
}

- (void)gitUtil:(JDGitUtil*)util pushMessageReceived:(NSString*)aMessage{
    [self addHerokuLog:aMessage];
}

- (void)gitUtilPushFinished:(JDGitUtil*)util{
    [self addHerokuLog:@"\n"];
    [self addHerokuLog:@"---- SYNC FINISHED ---\n"];
//    [JDUIUtil hudAlert:@"Sync Success" second:3];
//    [self.window.sheetParent c]
}

- (void)addHerokuLog:(NSString*)str{
    if ([str length]) {

        NSAttributedString* attr = [[NSAttributedString alloc] initWithString:str];
        
        [[_herokuTV textStorage] appendAttributedString:attr];
        [_herokuTV scrollRangeToVisible:NSMakeRange([[_herokuTV string] length], 0)];
    }
}

@end
