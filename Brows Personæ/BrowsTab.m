//
//  BrowsTab.m
//  Brows Personæ
//
//  Created by Taldar Baddley on 2014-10-12.
//  Copyright (c) 2014 Eightt. All rights reserved.
//

#import "BrowsTab.h"
#import "BrowsingSession.h"

#import <WebKit/WebKit.h>

@interface BrowsTab () {
    NSObject *tabViewButtonThing;
    WebView *webView;
    BrowsingSession *browsingSession;
}

@end



@implementation BrowsTab

- (id)init {
    if (!(self = [super initWithNibName:@"BrowsTab" bundle:nil])) return nil;
    
    // something
    
    return self;
}



@end
