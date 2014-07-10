//
//  LMCommandVC.m
//  IUEditor
//
//  Created by jd on 5/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMCommandVC.h"
#import "IUSheetGroup.h"
#import "IUDjangoProject.h"
#import "JDScreenRecorder.h"
#import "JDDateTimeUtil.h"
#import "LMTutorialManager.h"
#import "LMHelpWC.h"
#import "JDNetworkUtil.h"
#import "JDShellUtil.h"

@interface LMCommandVC ()
@property (weak) IBOutlet NSButton *buildB;
@property (weak) IBOutlet NSButton *serverB;
@property (weak) IBOutlet NSPopUpButton *compilerB;
@property (strong) IBOutlet NSWindow *portOccupiedWindow;
@property (weak) IBOutlet NSTextField *portOccupiedText;
@property (weak) IBOutlet NSButton *doNotShowAgainB;
@property (weak) IBOutlet NSButton *recordingB;

@property NSString *serverState;
@end

@implementation LMCommandVC {
    NSTask *serverTask;
    __weak NSButton *_buildB;
    __weak NSButton *_serverB;
    __weak NSPopUpButton *_compilerB;
    
    
    NSPipe *stdOutput;
    NSPipe *stdError;
    
    NSFileHandle *stdOutputHandle;
    NSFileHandle *stdErrorHandle;

    JDScreenRecorder *screenRecorder;
    JDShellUtil *debugServerShell;

    BOOL recording;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [_compilerB bind:NSSelectedIndexBinding toObject:self withKeyPath:@"docController.project.compiler.rule" options:nil];
        [self addObserver:self forKeyPath:@"docController.project.runnable" options:NSKeyValueObservingOptionInitial context:nil];
        [self changeCompilerRule:nil];
    });
}

-(void)dealloc{
    //release 시점 확인용
    NSAssert(0, @"");
    
    //[self removeObserver:self forKeyPath:@"docController.project.runnable"];
}


- (NSInteger)djangoDebugPort{
    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:@"DjangoDebugPort"];
    if (port == nil) {
        port = @"8000";
    }
    return [port integerValue];
}

-(void)docController_project_runnableDidChange:(NSDictionary*)change{
    if (_docController.project.runnable == NO) {
        [_serverB setEnabled:NO];
        [[_compilerB itemAtIndex:1] setEnabled:NO];
        [_compilerB setAutoenablesItems:NO];
    }
    else {
        [_serverB setEnabled:YES];
        [[_compilerB itemAtIndex:1] setEnabled:YES];
        [_compilerB setAutoenablesItems:YES];
    }
}

- (void)showPortKillSheet:(NSString*)port{
    NSInteger pid = [JDNetworkUtil pidOfPort:[port integerValue]];
    NSString *processName = [JDNetworkUtil processNameOfPort:[port integerValue]];
    NSString *str = [NSString stringWithFormat:@"Django debug port %@ is occupied by '%@ (PID %ld)'. Do you want to kill it?", port, processName, pid];
    [_portOccupiedText setStringValue:str];
    [self.view.window beginSheet:_portOccupiedWindow completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK) {
            //kill process
            NSString *command = [NSString stringWithFormat:@"kill %ld", pid];
            [JDShellUtil execute:command];

            //build again
            
        }
        else {
            return;
        }
    }];
    return;
}

- (void)shellUtil:(JDShellUtil*)util standardOutputDataReceived:(NSData*)data{
    NSString *log = [[NSString alloc] initWithData:data encoding:4];
    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleLog object:self.view userInfo:@{@"Log": log}];
}

- (void)shellUtil:(JDShellUtil*)util standardErrorDataReceived:(NSData*)data{
    NSString *log = [[NSString alloc] initWithData:data encoding:4];
    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleLog object:self.view userInfo:@{@"Log": log}];
}


- (IBAction)build:(id)sender {
    
    IUCompileRule rule = _docController.project.compiler.rule;
    if (rule == IUCompileRuleDefault) {
        IUProject *project = _docController.project;
        BOOL result = [project build:nil];
        if (result == NO) {
            NSAssert(0, @"");
        }
        IUSheet *doc = [[_docController selectedObjects] firstObject];
        NSString *firstPath = [project.directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.html",project.buildPath, [doc.name lowercaseString]] ];
        [[NSWorkspace sharedWorkspace] openFile:firstPath];
    }
    else if (rule == IUCompileRuleDjango){
        //get port
        //run server
        if ([debugServerShell.task isRunning] == NO) {
            if ([JDNetworkUtil isPortAvailable:[self djangoDebugPort]]) {
                [self runServer:nil];
            }
        }
        
        //compile
        IUProject *project = _docController.project;
        BOOL result = [project build:nil];
        if (result == NO) {
            NSAssert(0, @"compile failed");
        }
        
        //open page
        IUSheet *node = [[_docController selectedObjects] firstObject];
        if([node isKindOfClass:[IUSheet class]] == NO){
            node = [project.pageDocuments firstObject];
        }

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://127.0.0.1:%ld/%@",[self djangoDebugPort], [node.name lowercaseString]]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSWorkspace sharedWorkspace] openURL:url];
        });
    }
    
    //show tutorial if needed
    if ([LMTutorialManager shouldShowTutorial:@"run"]) {
        [[LMHelpWC sharedHelpWC] showHelpDocumentWithKey:@"RunningAProject"];
    }
}

- (BOOL) runServer:(NSError **)error{
    //get port
    NSString *command = [NSString stringWithFormat:@"%@ runserver %ld", [_docController.project.directoryPath stringByAppendingPathComponent:@"manage.py"], [self djangoDebugPort]];
    debugServerShell = [[JDShellUtil alloc] init];
    [debugServerShell execute:command delegate:self];
    [self refreshServerState];
    return YES;
}


- (IBAction)stopServer:(id)sender {
    // run server
    if (debugServerShell) {
        [debugServerShell stop];
        debugServerShell = nil;
    }
    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:@"DjangoDebugPort"];
    if (port == nil) {
        port = @"8000";
    }
    NSInteger pid = [JDNetworkUtil pidOfPort:[port integerValue]];
    if (pid != NSNotFound) {
        //kill
        NSString *killCommand = [NSString stringWithFormat:@"kill %ld", pid];
        [JDShellUtil execute:killCommand];
    }
    [self refreshServerState];
}

- (void)refreshServerState{
    [self refreshServerStatePerform];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshServerStatePerform];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshServerStatePerform];
    });

}

- (void)refreshServerStatePerform{
    NSInteger pid = [JDNetworkUtil pidOfPort:[self djangoDebugPort]];
    if (pid == NSNotFound) {
        self.serverState = nil;
        return;
    }
    NSString *processName = [JDNetworkUtil processNameOfPort:[self djangoDebugPort]];
    self.serverState = [NSString stringWithFormat:@"%@(%ld) is running", processName, pid];
}

- (IBAction)changeCompilerRule:(id)sender {
    _docController.project.compiler.rule = (int)[_compilerB indexOfSelectedItem];
    if (_docController.project.compiler.rule == IUCompileRuleDefault) {
        self.serverState = nil;
    }
    else {
        [self refreshServerState];
    }
}

- (IBAction)toggleRecording:(id)sender{
    if (recording == NO) {
        recording = YES;
        [_recordingB setImage:[NSImage imageNamed:@"record_stop"]];
        [JDUIUtil hudAlert:@"Recording Start" second:3];
        screenRecorder = [[JDScreenRecorder alloc] init];
        
        NSString *fileName = [NSString stringWithFormat:@"%@/Desktop/%@.mp4", NSHomeDirectory(), [JDDateTimeUtil stringForDate:[NSDate date] option:JDDateStringTimestampType2]];
        [screenRecorder startRecord:[NSURL fileURLWithPath:fileName]];
    }
    else {
        recording = NO;
        [_recordingB setImage:[NSImage imageNamed:@"record"]];
        [screenRecorder finishRecord];
        [JDUIUtil hudAlert:@"Recording saved at Desktop" second:3];
    }
}
- (IBAction)performCancelKillOccupiedProcess:(id)sender {
    if ([_doNotShowAgainB integerValue]) {
        //always yes
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"DebugPortKill"];
    }
    [self.view.window endSheet:_portOccupiedWindow returnCode:NSModalResponseCancel];
}

- (IBAction)performKillOccupiedProcess:(id)sender {
    if ([_doNotShowAgainB integerValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"DebugPortKill"];
    }
    [self.view.window endSheet:_portOccupiedWindow returnCode:NSModalResponseOK];
}


@end
