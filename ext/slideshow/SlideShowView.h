#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@interface SlideShowView : NSView

- (BOOL)isViewing;
- (void)setupTransition:(NSString*)transition;
- (void)transitionToImage:(NSImage *)newImage;

@end
