//
//  IUWordpressProject.m
//  IUEditor
//
//  Created by jd on 2014. 7. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUWordpressProject.h"
#import "IUEventVariable.h"
#import "JDShellUtil.h"

#import "IUBackground.h"
#import "IUPage.h"
#import "IUClass.h"

@implementation IUWordpressProject

- (id)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}

- (BOOL)runnable{
    return YES;
}

- (id)initWithCreation:(NSDictionary *)options error:(NSError *__autoreleasing *)error{
    _mqSizes = [NSMutableArray arrayWithArray:@[@(defaultFrameWidth), @320]];
    
    
    _compiler = [[IUCompiler alloc] init];
    _resourceManager = [[IUResourceManager alloc] init];
    _compiler.resourceManager = _resourceManager;
    _identifierManager = [[IUIdentifierManager alloc] init];
    
    NSAssert(options[IUProjectKeyAppName], @"app Name");
    NSAssert(options[IUProjectKeyIUFilePath], @"path");
    
    self.name = [options objectForKey:IUProjectKeyAppName];
    self.path = [options objectForKey:IUProjectKeyIUFilePath];
    
    _buildPath = @"$IUFileDirectory/$AppName";
    _buildResourcePath = @"$IUFileDirectory/$AppName/resource";

    _pageGroup = [[IUSheetGroup alloc] init];
    _pageGroup.name = IUPageGroupName;
    _pageGroup.project = self;
    
    _backgroundGroup = [[IUSheetGroup alloc] init];
    _backgroundGroup.name = IUBackgroundGroupName;
    _backgroundGroup.project = self;
    
    _classGroup = [[IUSheetGroup alloc] init];
    _classGroup.name = IUClassGroupName;
    _classGroup.project = self;
    
    IUBackground *bg = [[IUBackground alloc] initWithProject:self options:nil];
    bg.name = @"background";
    bg.htmlID = @"background";
    [self addSheet:bg toSheetGroup:_backgroundGroup];
    
    IUPage *index = [[IUPage alloc] initWithProject:self options:nil];
    [index setBackground:bg];
    index.name = @"index";
    index.htmlID = @"index";
    [self addSheet:index toSheetGroup:_pageGroup];
    
    IUPage *page = [[IUPage alloc] initWithProject:self options:nil];
    [page setBackground:bg];
    page.name = @"page";
    page.htmlID = @"page";
    [self addSheet:page toSheetGroup:_pageGroup];

    IUPage *_404 = [[IUPage alloc] initWithProject:self options:nil];
    [_404 setBackground:bg];
    _404.name = @"404";
    _404.htmlID = @"404";
    [self addSheet:_404 toSheetGroup:_pageGroup];
    

    IUClass *class = [[IUClass alloc] initWithProject:self options:nil];
    class.name = @"class";
    class.htmlID = @"class";
    [self addSheet:class toSheetGroup:_classGroup];
    
    [self initializeResource];
    [_resourceManager setResourceGroup:_resourceGroup];
    [_identifierManager registerIUs:self.allDocuments];
    
    //    ReturnNilIfFalse([self save]);
    _serverInfo = [[IUServerInfo alloc] init];
    _serverInfo.localPath = [self path];
    return self;
}


- (NSString*)absoluteBuildPathForSheet:(IUSheet *)sheet{
    NSString *extension = (self.compiler.rule == IUCompileRuleWordpress) ? @"php" : @"html";
    NSString *filePath = [[self.absoluteBuildPath stringByAppendingPathComponent:sheet.name ] stringByAppendingPathExtension:extension];
    return filePath;
}

- (BOOL)build:(NSError *__autoreleasing *)error{
    BOOL result = [super build:error];
    if (result) {
        NSString *path = [self absoluteBuildPath];
        NSString *command = [NSString stringWithFormat:@"touch %@", [path stringByAppendingPathComponent:@"style.css"]];
        [JDShellUtil execute:command];
    }
    return result;
}

@end
