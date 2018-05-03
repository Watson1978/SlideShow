#import "AppDelegate.h"
#import "SlideShowView.h"

// 内部用
@interface AppDelegate ()

@property (nonatomic) SlideShowView *slideShowView;
@property (nonatomic) NSMutableArray<NSImage*> *photos;
@property (nonatomic) BOOL isBlank;

@end

@implementation AppDelegate

- (instancetype)init {
    if (self = [super init]) {
        self.interval = 5.0;
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.slideShowView = [[SlideShowView alloc] initWithFrame:self.window.contentView.bounds];
    self.slideShowView.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    if (self.transition) {
        [self.slideShowView setupTransition:self.transition];
    }
    [self.window.contentView addSubview:self.slideShowView];

    if ([self.paths count]) {
        self.photos = NSMutableArray.new;

        __weak __typeof(self) wself = self;
        for (NSURL *url in self.paths) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSImage *photo = [[NSImage alloc] initWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!wself) { return; }

                    [wself.photos addObject:photo];
                    if (![wself.slideShowView isViewing]) {
                        [wself.slideShowView transitionToImage:photo];
                    }
                });
            });
        }

        [NSTimer scheduledTimerWithTimeInterval:self.interval repeats:YES block: ^(NSTimer *timer) {
            if (!wself) { return; }
            if (wself.photos.count == 0) { return; }

            int index = rand() % wself.photos.count;
            [wself.slideShowView transitionToImage:wself.photos[index]];
        }];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    exit(0);
}

@end
