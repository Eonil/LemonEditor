//
//  IUWordpressProject.m
//  IUEditor
//
//  Created by jd on 2014. 7. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUWordpressProject.h"
#import "IUEventVariable.h"
@implementation IUWordpressProject

- (id)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}

- (BOOL)runnable{
    return YES;
}

- (BOOL)build:(NSError *__autoreleasing *)error{
    NSAssert(self.buildPath != nil, @"");
    NSString *buildPath = [self.directoryPath stringByAppendingPathComponent:self.buildPath];
    NSString *buildResourcePath = [self.directoryPath stringByAppendingPathComponent:self.buildResourcePath];
    
    [[NSFileManager defaultManager] removeItemAtPath:buildPath error:error];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:buildPath withIntermediateDirectories:YES attributes:nil error:error];
    
    //    [self initializeResource];
    
    [[NSFileManager defaultManager] copyItemAtPath:_resourceGroup.absolutePath toPath:buildResourcePath error:error];
    
    
    IUEventVariable *eventVariable = [[IUEventVariable alloc] init];
    JDCode *initializeJSSource = [[JDCode alloc] init];
    
    for (IUSheet *doc in self.allDocuments) {
        NSString *outputString = [doc outputSource];
        
        NSString *filePath = [[buildPath stringByAppendingPathComponent:[doc.name lowercaseString]] stringByAppendingPathExtension:@"php"];
        if ([outputString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:error] == NO){
            NSAssert(0, @"write fail");
        }
        
        [eventVariable makeEventDictionary:doc];
        
        [initializeJSSource addCodeLineWithFormat:@"/* Initialize %@ */\n", doc.name];
        [initializeJSSource addCodeLine:[doc outputInitJSSource]];
        [initializeJSSource addNewLine];
    }
    
    NSString *resourceJSPath = [buildResourcePath stringByAppendingPathComponent:@"js"];
    
    //make initialize javascript file
    
    NSString *iuinitFilePath = [[NSBundle mainBundle] pathForResource:@"iuinit" ofType:@"js"];
    
    JDCode *sourceCode = [[JDCode alloc] initWithCodeString: [NSString stringWithContentsOfFile:iuinitFilePath encoding:NSUTF8StringEncoding error:nil]];
    [sourceCode replaceCodeString:@"/*INIT_JS_REPLACEMENT*/" toCode:initializeJSSource];
    
    
    NSString *initializeJSPath = [[resourceJSPath stringByAppendingPathComponent:@"iuinit"] stringByAppendingPathExtension:@"js"];
    NSError *myError;
    if ([sourceCode.string writeToFile:initializeJSPath atomically:YES encoding:NSUTF8StringEncoding error:&myError] == NO){
        NSAssert(0, @"write fail");
    }
    
    
    //make event javascript file
    NSString *eventJSString = [eventVariable outputEventJSSource];
    NSString *eventJSFilePath = [[resourceJSPath stringByAppendingPathComponent:@"iuevent"] stringByAppendingPathExtension:@"js"];
    if ([eventJSString writeToFile:eventJSFilePath atomically:YES encoding:NSUTF8StringEncoding error:error] == NO){
        NSAssert(0, @"write fail");
    }
    
    [JDUIUtil hudAlert:@"Build Success" second:2];
    return YES;
}

@end
