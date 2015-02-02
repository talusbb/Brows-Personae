//
//  BrowsTab.h
//  Brows Personæ
//
//  Created by Taldar Baddley on 2014-10-12.
//  Copyright (c) 2014 Eightt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
@class SiteProfile;


@interface BrowsTab : NSViewController {
    IBOutlet WebView *pageView;
    IBOutlet NSVisualEffectView *tooblar;
}

- (instancetype)initWithProfile:(SiteProfile *)profile;
- (instancetype)initWithProfileNamed:(NSString *)profileName;

- (NSImage *)thumbnail;
- (NSImage *)favicon;

@end
