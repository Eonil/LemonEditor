//
//  IURender.m
//  IUEditor
//
//  Created by jd on 4/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUImport.h"
#import "IUBox.h"
#import "IUClass.h"

@implementation IUImport

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self.undoManager disableUndoRegistration];
    
    if(self){
        self.prototypeClass = [aDecoder decodeObjectForKey:@"_prototypeClass"];
    }
    
    [self.undoManager enableUndoRegistration];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:_prototypeClass forKey:@"_prototypeClass"];
}

- (id)copyWithZone:(NSZone *)zone{
    IUImport *iu = [super copyWithZone:zone];
    [self.undoManager disableUndoRegistration];
    [self.delegate disableUpdateAll:self];

    
    iu.prototypeClass = _prototypeClass;

    [self.delegate enableUpdateAll:self];
    [self.undoManager enableUndoRegistration];
    return iu;
}

- (void)connectWithEditor{
    
    NSAssert(self.project, @"");
    
    
    [[self undoManager] disableUndoRegistration];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMQSelect:) name:IUNotificationMQSelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMQSize:) name:IUNotificationMQAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMQSize:) name:IUNotificationMQRemoved object:nil];
    
    
    
    [[self undoManager] enableUndoRegistration];
    
}

- (void)prepareDealloc{
    
}

- (void)setPrototypeClass:(IUClass *)prototypeClass{
    
    if([prototypeClass isEqualTo:_prototypeClass]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setPrototypeClass:_prototypeClass];

    [self willChangeValueForKey:@"children"];
    
    [_prototypeClass removeReference:self];
    
    if(prototypeClass == nil){
        //remove layers
        for(IUBox *box in _prototypeClass.allChildren){
            NSString *modifiedHTMLID = [NSString stringWithFormat:@"ImportedBy_%@_%@",self.htmlID, box.htmlID];
            [self.delegate IURemoved:modifiedHTMLID withParentID:self.htmlID];
        }
        
        NSString *modifiedHTMLID = [NSString stringWithFormat:@"ImportedBy_%@_class",self.htmlID];
        [self.delegate IURemoved:modifiedHTMLID withParentID:self.htmlID];

    }
    
    _prototypeClass = prototypeClass;
    _prototypeClass.delegate = self.delegate;
 
    [_prototypeClass addReference:self];
    [self updateHTML];
    if (self.delegate) {
        for (IUBox *iu in [prototypeClass.allChildren arrayByAddingObject:prototypeClass]) {
            [iu updateCSS];
        }
    }
    [self didChangeValueForKey:@"children"];
}


- (void)setDelegate:(id<IUSourceDelegate>)delegate{
    [super setDelegate:delegate];
    _prototypeClass.delegate = delegate;
}

- (NSArray*)children{
    if (_prototypeClass == nil) {
        return [NSArray array];
    }
    return @[_prototypeClass];
}

- (BOOL)shouldAddIUByUserInput{
    return NO;
}


- (NSMutableArray *)allIdentifierChildren{
    NSMutableArray *array =  [self allChildren];
    [array removeObject:_prototypeClass];
    [array removeObjectsInArray:[_prototypeClass allChildren]];
    return array;
}



@end
