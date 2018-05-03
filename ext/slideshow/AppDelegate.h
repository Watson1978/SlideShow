#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

// Ruby とやり取りするためのインタフェース
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, retain) NSWindow *window;
@property (nonatomic, copy) NSArray<NSURL*> *paths;
@property (nonatomic) NSTimeInterval interval;

@end
