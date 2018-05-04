#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <AppKit/AppKit.h>

// Ruby とやり取りするためのインタフェース
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic) NSWindow *window;
@property (nonatomic, copy) NSArray<NSURL*> *paths;
@property (nonatomic, copy) NSString *transition;
@property (nonatomic) NSTimeInterval interval;

@end
