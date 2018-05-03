#import "AppDelegate.h"

// 内部用
@interface AppDelegate ()
@property (nonatomic, retain) NSImageView *imageView;
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
    self.imageView = [[NSImageView alloc] initWithFrame:self.window.contentView.bounds];
    self.imageView.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    [self.window.contentView addSubview:self.imageView];

    if ([self.paths count]) {
        self.photos = NSMutableArray.new;

        for (NSURL *url in self.paths) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSImage *photo = [[NSImage alloc] initWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.photos addObject:photo];
                    if (self.imageView.image == nil) {
                        self.imageView.image = photo;
                    }
                });
            });
        }

        __weak __typeof(self) wself = self;
        [NSTimer scheduledTimerWithTimeInterval:self.interval repeats:YES block: ^(NSTimer *timer) {
            if (!wself) { return; }
            if (wself.photos.count == 0) { return; }

            int index = rand() % wself.photos.count;
            wself.imageView.image = wself.photos[index];
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
