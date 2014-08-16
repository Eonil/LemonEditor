//
//  IUProtocols.h
//  IUEditor
//
//  Created by jd on 2014. 8. 3..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IUSampleHTMLProtocol
@required
- (NSString*)sampleHTML;
@end

@protocol IUCodeProtocol
@optional
- (NSString*)prefixCode;
- (NSString*)postfixCode;
- (NSString*)code;
@end

@protocol IUWordpressCodeProtocol
@optional
- (NSString*)functionCode;
@end