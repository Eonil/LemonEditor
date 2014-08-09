//
//  IUWordpressProject.h
//  IUEditor
//
//  Created by jd on 2014. 7. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUProject.h"
#import "IUPage.h"

@interface IUWordpressProject : IUProject

- (IUPage *)newPagePHPFile;
- (IUPage *)createHomePHPFile;
- (IUPage *)create404PHPFile;
- (IUPage * *)createIndexPHPFile;
- (IUPage *)createCategoryPHPFile;
- (IUPage *)createCustomPHPFile:(NSString*)filename;
@end
