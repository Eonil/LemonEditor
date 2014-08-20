//
//  WPMenu.m
//  IUEditor
//
//

#import "WPMenu.h"

@implementation WPMenu

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    self.itemCount = 4;
    self.fullWidthMenu = NO;
    self.leftRightPadding = 16;
    self.align = IUAlignLeft;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[WPMenu class] properties]];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [aDecoder decodeToObject:self withProperties:[[WPMenu class] properties]];
    return self;
}

- (void)setItemCount:(NSInteger)itemCount{
    _itemCount = itemCount;
    [self updateHTML];
}
- (NSString*)sampleInnerHTML{
    NSMutableString *returnText = [NSMutableString stringWithString:@"<div class='menu-samplemenu-container'><ul id='menu-samplemenu'>\
                                   <li id='menu-item-01' class='menu-item'>JDLab blog</li>"];
    if (_itemCount > 1) {
        [returnText appendString:@"<li id='menu-item-02' class='menu-item'>Rosa</li>"];
    }
    if (_itemCount > 2) {
        [returnText appendString:@"<li id='menu-item-03' class='menu-item'>Eschscholzia Californica</li>"];
    }
    if (_itemCount > 3) {
        [returnText appendString:@"<li id='menu-item-04' class='menu-item'>Camellia japonica</li>"];
    }
    if (_itemCount > 4) {
        [returnText appendString:@"<li id='menu-item-05' class='menu-item'>Malus</li>"];
    }
    if (_itemCount > 5) {
        [returnText appendString:@"<li id='menu-item-06' class='menu-item'>Kalmia latifolia</li>"];
    }
    if (_itemCount > 6) {
        [returnText appendString:@"<li id='menu-item-07' class='menu-item'>Pinus strobus</li>"];
    }
    [returnText appendString:@"</ul></div>"];
    return [returnText copy];
}

-(BOOL)shouldCompileFontInfo{
    return YES;
}

-(NSString*)code{
    return @"<? wp_nav_menu() ?>";
}
@end
