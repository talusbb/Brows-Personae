//
//  BrowsWindow.m
//  Brows Personæ
//
//  Created by Taldar Baddley on 2014-10-12.
//  Copyright (c) 2014 Eightt. All rights reserved.
//


#import "BrowsWindow.h"

#import <tgmath.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BrowsTab.h"
#import "BrowsTabList.h"
#import "BrowsTabTableCellView.h"
#import "MktabController.h"





@interface BrowsWindow () {
    NSArray *initialTabs;
    
    dispatch_once_t didInitNewtab;
    MktabController *newtabController;
    __weak NSPopover *newtabPopover;
    
}

@end





@implementation BrowsWindow



- (id)initWithTabs:(NSArray *)tabs {
    if (!(self = [super initWithWindowNibName:@"BrowsWindow"])) return nil;
    
    initialTabs = [tabs copy];
    
    return self;
}



- (id)init {
    return [self initWithTabs:@[ ]];
}



- (NSArray *)tabs {
    return [tabsListController tabs];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    [tabsList registerNib:[[NSNib alloc] initWithNibNamed:@"TabCell" bundle:[NSBundle mainBundle]]
            forIdentifier:@"BrowsTabCell"];
    
    if (initialTabs)
        [tabsListController swapTabs:initialTabs];
    initialTabs = nil;
    
}




- (void)windowDidLoad {
    [super windowDidLoad];
    [[self window] setDelegate:self];
    
    [[self window] setStyleMask: [[self window] styleMask] | NSFullSizeContentViewWindowMask ];  // Set here for easier layout in nib.
//    [[self window] setTitleVisibility:NSWindowTitleHidden];
    [[self window] setTitlebarAppearsTransparent:YES];
    
    NSRect windyFrame = [[self window] frame];
    windyFrame.origin.y = 0;
    windyFrame.size.height = 10000;
    [[self window] setFrame:windyFrame display:YES];
    
    if ([[tabsListController tabs] count]) {
        // Replace with last-selected indices.
        [tabsList selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        
    } else {
        // Mktab!
        dispatch_async(dispatch_get_main_queue(), ^{
            [self newTab:newTabButton];
        });
        
    }
    
    @weakify(noTabPlaceholder)
    @weakify(multiTabsPlaceholder)
    RACSignal *viewForTabSelection =[[tabsListController tabSelection] map:^id(NSArray *selTabs) {
        @strongify(noTabPlaceholder) @strongify(multiTabsPlaceholder)
        
        switch ([selTabs count]) {
            case 1:
                return [[selTabs objectAtIndex:0] view];
                
            case 0:
                return noTabPlaceholder;
                
            default:
                return multiTabsPlaceholder;
                
        }
        
    }];
    
    @weakify(windowBody)
    [viewForTabSelection subscribeNext:^(NSView *selTab) {
        @strongify(windowBody)
        
        [windowBody setSubviews:@[selTab]];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(selTab);
        [windowBody addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[selTab]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
        [windowBody addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[selTab]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
        
    }];
    
    
}



- (void)windowWillClose:(NSNotification *)notification {
    [tabsListController swapTabs:@[]];
    tabsListController = nil;
}



- (IBAction)newTab:(id)sender {
    dispatch_once(&didInitNewtab, ^{
        newtabController = [[MktabController alloc] initWithBrowsWindow:self];
    });
    
    NSPopover *pop = newtabPopover;
    if (pop) return;
    
    newtabPopover = pop = [[NSPopover alloc] init];
    [pop setContentViewController:newtabController];
    [pop setBehavior:NSPopoverBehaviorSemitransient];
    
    [pop showRelativeToRect:[newTabButton bounds]
                     ofView:newTabButton
              preferredEdge:NSMaxYEdge];
    
}


- (void)finalizeNewTabPanelWithTab:(BrowsTab *)tab {
    [newtabPopover performClose:nil];
    newtabPopover = nil;  // just in case
    
    if (!tab) return;
    
    [tabsListController putTab:tab];
    [tabsList selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    
}






@end


















