//
//  LMDebugSourceWC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 3..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMDebugSourceWC.h"

@interface LMDebugSourceWC ()
@property (weak) IBOutlet NSSearchField *searchField;
@property (strong) IBOutlet NSTextFinder *textFinder;
@property (unsafe_unretained) IBOutlet NSTextView *codeTextView;
@end

@implementation LMDebugSourceWC{
    NSRange currentFindRange;
}


- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [_codeTextView setSelectedTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSColor highlightColor], NSBackgroundColorAttributeName,
      [NSColor blackColor], NSForegroundColorAttributeName,
      nil]];
    
}
- (void)setCurrentSource:(NSString *)source{
    [_codeTextView setString:source];
}

- (IBAction)searchField:(id)sender {
    NSString *searchString = [sender stringValue];
    currentFindRange = [[_codeTextView string] rangeOfString:searchString];
    [self showSearch];
    [self setColoringToSearcinString];
}

- (void)setColoringToSearcinString{
    
    NSString *searchString = [_searchField stringValue];
    NSString *wholeString = [_codeTextView string];

    NSRange findRange = [wholeString rangeOfString:searchString];
    NSMutableArray *selecteRanges = [NSMutableArray array];
    while(findRange.location != NSNotFound){
        [selecteRanges addObject:[NSValue valueWithRange:findRange]];
        
        NSUInteger start = findRange.length + findRange.location;
        findRange =  [wholeString rangeOfString:searchString options:NSCaseInsensitiveSearch range:NSMakeRange(start, wholeString.length -start)];
        
    }
    
    [_codeTextView setSelectedRanges:selecteRanges];
}

- (IBAction)previousSearch:(id)sender {
    NSString *wholeString = [_codeTextView string];

    if(currentFindRange.location == NSNotFound){
        currentFindRange = NSMakeRange(wholeString.length, 0);
    }
    
    
    NSString *searchString = [_searchField stringValue];
    currentFindRange = [wholeString rangeOfString:searchString options:NSCaseInsensitiveSearch|NSBackwardsSearch range:NSMakeRange(0, currentFindRange.location)];
    [self showSearch];
    
}
- (IBAction)nextSearch:(id)sender {
    if(currentFindRange.location == NSNotFound){
        currentFindRange = NSMakeRange(0, 0);
    }
    
    NSString *searchString = [_searchField stringValue];
    NSString *wholeString = [_codeTextView string];
    NSUInteger start = currentFindRange.length + currentFindRange.location;
    currentFindRange =  [wholeString rangeOfString:searchString options:NSCaseInsensitiveSearch range:NSMakeRange(start, wholeString.length -start)];
    [self showSearch];
    
}


- (void)showSearch{
    if(currentFindRange.location != NSNotFound){
        [_codeTextView showFindIndicatorForRange:currentFindRange];
    }
}

#pragma mark - button

- (IBAction)applyCurrentSource:(id)sender {
#if DEBUG
    NSString *html = [_codeTextView string];
    [_canvasVC applyHtmlString:html];
#endif
}
- (IBAction)reloadOriginalSource:(id)sender {
#if DEBUG
    [_canvasVC reloadOriginalDocument];
#endif
}

@end
