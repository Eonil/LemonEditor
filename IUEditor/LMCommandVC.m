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

@interface LMCommandVC ()
@property (weak) IBOutlet NSButton *buildB;
@property (weak) IBOutlet NSButton *stopServerB;
@property (weak) IBOutlet NSPopUpButton *compilerB;
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
    JDShellUtil *restartServerShell;
    JDSyncUtil *syncUtil;

    BOOL recording;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)unbindAllBinding{
    [self removeObserver:self forKeyPath:@"docController.project.runnable"];
    [_compilerB unbind:NSSelectedIndexBinding];
}

- (void)awakeFromNib{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [_compilerB bind:NSSelectedIndexBinding toObject:self withKeyPath:@"docController.project.compiler.rule" options:nil];
        [self addObserver:self forKeyPath:@"docController.project.runnable" options:NSKeyValueObservingOptionInitial context:nil];
        [self changeCompilerRule:nil];
#ifndef DEBUG
        [_recordingB setHidden:YES];
#endif
        syncUtil = [[JDSyncUtil alloc] init];
        syncUtil.delegate = self;
    });
}

-(void)dealloc{
    if(syncUtil){
        [self removeObserver:self forKeyPath:@"docController.project.runnable"];
    }
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
    if (rule == IUCompileRuleDefault || rule == IUCompileRuleWordpress) {
        IUProject *project = _docController.project;
        BOOL result = [project build:nil];
        if (result == NO) {
            NSAssert(0, @"");
        }
        IUSheet *doc = [[_docController selectedObjects] firstObject];
        if (rule == IUCompileRuleDefault) {
            NSString *firstPath = [project buildPathForSheet:doc];
            if ([[firstPath pathExtension] isEqualTo:@"html"]) {
                [[NSWorkspace sharedWorkspace] openFile:firstPath];
            }
            else {
                [[NSWorkspace sharedWorkspace] openFile:firstPath withApplication:@"Coda 2"];
            }
        }
        else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1/~%@/wordpress", NSUserName()]];
            [[NSWorkspace sharedWorkspace] openURL:url];
        }
    }
    else if (rule == IUCompileRuleDjango){
        //get port
        //run server
        if ([debugServerShell.task isRunning] == NO) {
            if ([JDNetworkUtil isPortAvailable:[self djangoDebugPort]]) {
                BOOL result = [self runServer:nil];
                if (result == NO) {
                    return;
                }
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
            node = [project.pageSheets firstObject];
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
    NSString *filePath = [_docController.project.directoryPath stringByAppendingPathComponent:@"manage.py"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        [JDUIUtil hudAlert:@"No manage.py" second:2];
        return NO;
    }
    NSString *command = [NSString stringWithFormat:@"%@ runserver %ld",filePath , [self djangoDebugPort]];
    if ([debugServerShell.task isRunning] == NO) {
        debugServerShell = [[JDShellUtil alloc] init];
        [debugServerShell execute:command delegate:self];
    }
    [self refreshServerState];
    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleStart object:self.view.window];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleEnd object:self.view.window];
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
    if (_docController.project.compiler.rule == IUCompileRuleDjango) {
        [self refreshServerState];
        [self.stopServerB setHidden:NO];
    }
    else {
        self.serverState = nil;
        [self.stopServerB setHidden:YES];
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


#pragma mark -
#pragma mark Upload

- (IBAction)upload:(id)sender{
    if (syncUtil.isSyncing) {
        [JDLogUtil alert:@"Upload was Progressing. Kill it and start new uploading"];
        [syncUtil terminate];
    }
        IUServerInfo *info = [self.docController.project serverInfo];
        if ([info isSyncValid]) {
            syncUtil.user = info.syncUser;
            syncUtil.host = info.host;
            syncUtil.password = info.syncPassword;
            syncUtil.protocol = 0;
            syncUtil.remoteDirectory = info.remotePath;
            syncUtil.localDirectory = info.localPath;
            syncUtil.syncDirectory = info.syncItems;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleStart object:self.view.window userInfo:nil];
            [syncUtil upload];
        }
        else {
            [JDLogUtil alert:@"server info not valid. click project and set server info."];
        }
}


- (void)syncUtilReceivedStdOutput:(NSString*)aMessage{
    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleLog object:self.view.window userInfo:@{IUNotificationConsoleLogText: aMessage}];
    
}
- (void)syncUtilReceivedStdError:(NSString*)aMessage{
    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleLog object:self.view.window userInfo:@{IUNotificationConsoleLogText: aMessage}];
}

- (void)syncFinished:(int)terminationStatus{
    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleEnd object:self.view.window userInfo:nil];
    
}


- (IBAction)serverRestart:(id)sender{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ssh" ofType:@"sh"];
    IUServerInfo *serverInfo = [self.docController.project serverInfo];
    
    if (serverInfo.restartPassword && serverInfo.host && serverInfo.restartCommand) {
        NSString *command = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",filePath , serverInfo.restartUser, serverInfo.restartPassword, serverInfo.host, serverInfo.restartCommand];
        
        
        restartServerShell = [[JDShellUtil alloc] init];
        [restartServerShell execute:command delegate:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleStart object:self.view.window];
    }
    else {
        [JDLogUtil alert:@"Set Project Property First"];
    }
}

- (void) shellUtilExecutionFinished:(JDShellUtil *)util{
    if (util.name) {
        NSString *log = [NSString stringWithFormat:@" ------ %@ Ended -----", util.name];
        [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleLog object:self.view.window userInfo:@{IUNotificationConsoleLogText: log}];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleEnd object:self.view.window];
}

- (IBAction)download:(id)sender{
    if (syncUtil.isSyncing) {
        [JDLogUtil alert:@"Syncing was Progressing. Kill it and start new downloading"];
        [syncUtil terminate];
    }
    IUServerInfo *info = [self.docController.project serverInfo];
    if ([info isSyncValid]) {
        syncUtil.user = info.syncUser;
        syncUtil.host = info.host;
        syncUtil.password = info.syncPassword;
        syncUtil.protocol = 0;
        syncUtil.remoteDirectory = info.remotePath;
        syncUtil.localDirectory = info.localPath;
        syncUtil.syncDirectory = info.syncItems;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationConsoleStart object:self.view.window userInfo:nil];
        syncUtil.tag = 0; //0 for download, 1 for upload
        [syncUtil download];
    }
    else {
        [JDLogUtil alert:@"server info not valid. click project and set server info."];
    }
}


@end
