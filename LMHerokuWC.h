//
//  LMHerokuWC.h
//  IUEditor
//
//  Created by jd on 2014. 7. 29..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMHerokuWC : NSWindowController

- (IBAction)sync:(id)sender;
- (void)setGitRepoPath:(NSString*)path;
- (NSString*)gitRepoPath;
@end
