#import "SlideShowView.h"
#import <Quartz/Quartz.h>

@interface SlideShowView ()

@property (nonatomic) NSImageView *imageView;

@end

@implementation SlideShowView

- (void)drawRect:(NSRect)rect {
    [NSColor.blackColor set];
    NSRectFill(rect);
}

- (BOOL)isViewing {
	if (self.imageView && self.imageView.image) {
		return YES;
	}
	return NO;
}

- (void)setupTransition:(NSString*)transition {
	self.layerUsesCoreImageFilters = YES;
    self.wantsLayer = YES;

	CIFilter *transitionFilter = [CIFilter filterWithName:transition];
	[transitionFilter setDefaults];

	CATransition *newTransition = [CATransition animation];

	if (transitionFilter) {
		newTransition.filter = transitionFilter;
	} else {
	    newTransition.type = transition;
    	newTransition.subtype = kCATransitionFromLeft;
	}
 	newTransition.duration = 0.5;
    [self setAnimations:@{@"subviews": newTransition}];
}

- (void)transitionToImage:(NSImage *)newImage {
	NSImageView *newImageView = [[NSImageView alloc] initWithFrame:self.bounds];
    newImageView.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    newImageView.image = newImage;

	if (self.imageView && newImage) {
		[self.animator replaceSubview:self.imageView with:newImageView];
	} else {
		if (self.imageView) {
			[self.imageView.animator removeFromSuperview];
		}
		[self.animator addSubview:newImageView];
	}
	self.imageView = newImageView;
}
@end
