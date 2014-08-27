//
//  LMStartNewDefaultVC.m
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartNewDefaultVC.h"
#import "JDFileUtil.h"
#import "IUProject.h"
#import "LMAppDelegate.h"
#import "LMWC.h"
#import "IUProjectController.h"
#import "LMStartNewVC.h"

@interface LMStartNewDefaultVC ()

@property (nonatomic) NSString *defaultProjectDir, *appName;
@property (nonatomic) NSString *wholeName;


@end

@implementation LMStartNewDefaultVC

- (void)performNext{
    [self.view.window close];
    
    
    NSDictionary *options = @{  IUProjectKeyGit: @(NO),
                                IUProjectKeyHeroku: @(NO),
                                IUProjectKeyType:@(IUProjectTypeDefault),
                                IUProjectKeyAppName : _appName,
                                IUProjectKeyIUFilePath : _wholeName,
                                };
    
    [(IUProjectController *)[NSDocumentController sharedDocumentController] newDocument:self withOption:options];
}

- (void)performPrev{
    NSAssert(_parentVC, @"");
    [_parentVC show];
}

- (void)show{
    NSAssert(_parentVC, @"");
    NSAssert(_nextB, @"");
    NSAssert(_prevB, @"");
    NSAssert(_nextB != _prevB, @"");
    
    [_nextB setEnabled:YES];
    [_prevB setEnabled:YES];
    
    _prevB.target = self;
    _nextB.target = self;
    [_prevB setAction:@selector(performPrev)];
    [_nextB setAction:@selector(performNext)];
}

- (IBAction)performProjectDirSelect:(id)sender {
    self.defaultProjectDir = [[[JDFileUtil util] openDirectoryByNSOpenPanelWithTitle:@"Select Default Project Directory"] path];
}

- (void)setDefaultProjectDir:(NSString *)defaultProjectDir{
    [self willChangeValueForKey:@"wholeName"];
    _defaultProjectDir = defaultProjectDir;
    [self didChangeValueForKey:@"wholeName"];
}

- (void)setAppName:(NSString *)appName{
    [self willChangeValueForKey:@"wholeName"];
    _appName = appName;
    [self didChangeValueForKey:@"wholeName"];
}

- (NSString *)wholeName{
    NSString *iuName = [_appName stringByAppendingPathExtension:@"iu"];
    return [_defaultProjectDir stringByAppendingPathComponent:iuName];
}

@end
