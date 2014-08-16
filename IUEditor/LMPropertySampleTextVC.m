//
//  LMPropertyWPArticleBodyVC.m
//  IUEditor
//
//  Created by jd on 8/14/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertySampleTextVC.h"

@interface LMPropertySampleTextVC ()
@property (unsafe_unretained) IBOutlet NSTextView *sampleTextV;
@end

@implementation LMPropertySampleTextVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib{
    [self outlet:_sampleTextV bind:NSValueBinding property:@"sampleHTML"];
}

@end
