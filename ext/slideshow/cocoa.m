#import <ruby.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

//----------------------------------------
// SlideShow アプリの実体
//----------------------------------------

// Ruby とやり取りするためのインタフェース
@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (nonatomic, retain) NSWindow *window;
@property (nonatomic, copy) NSArray<NSURL*> *paths;
@property (nonatomic) NSTimeInterval interval;
@end

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
    self.imageView = [[NSImageView alloc] init];
    self.imageView.frame = self.window.contentView.bounds;
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

//----------------------------------------
// Ruby メソッドの実装
//----------------------------------------
static VALUE rb_cApplication;

// Rubyの文字列を NSString に変換する
static NSString *
convert_to_nsstring(VALUE string)
{
    return [NSString stringWithUTF8String:StringValueCStr(string)];
}

static VALUE
application_initialize(VALUE recv)
{
    NSApplication *app = [NSApplication sharedApplication];
    AppDelegate *delegate = AppDelegate.new;
    app.delegate = delegate;

    NSWindow *window = [[NSWindow alloc] initWithContentRect: NSMakeRect(0, 0, 640, 480)
                                                   styleMask: NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskResizable
                                                     backing: NSBackingStoreBuffered
                                                       defer: NO];
    [window display];
    [window orderFrontRegardless];
    delegate.window = window;
    return recv;
}

static VALUE
application_title(VALUE recv, VALUE title)
{
    NSApplication *app = [NSApplication sharedApplication];
    AppDelegate *delegate = app.delegate;
    delegate.window.title = convert_to_nsstring(title);
    return recv;
}

static VALUE
application_photo_paths(VALUE recv, VALUE ary)
{
    NSApplication *app = [NSApplication sharedApplication];
    AppDelegate *delegate = app.delegate;
    NSMutableArray<NSURL*> *paths = NSMutableArray.new;

    // Ruby 配列からファイルパスを取得
    int count = RARRAY_LEN(ary);
    for (int i = 0; i < count; i++) {
        VALUE p = RARRAY_AREF(ary, i);
        NSString *path = convert_to_nsstring(p);
        NSURL *url = [NSURL URLWithString:path];
        [paths addObject:url];
    }
    delegate.paths = paths;

    return recv;
}

static VALUE
application_interval(VALUE recv, VALUE interval)
{
    NSApplication *app = [NSApplication sharedApplication];
    AppDelegate *delegate = app.delegate;

    if (FIXNUM_P(interval)) {
        // Ruby 整数
        delegate.interval = (NSTimeInterval)FIX2LONG(interval);
    } else {
        // 整数以外は、暗黙的に Float に変換
        VALUE fval = rb_Float(interval);
        delegate.interval = (NSTimeInterval)NUM2DBL(fval);
    }

    return recv;
}

static VALUE
application_run(VALUE recv)
{
    NSApplication *app = [NSApplication sharedApplication];
    [app run];
    return recv;
}

// Ruby クラスとメソッドの定義
void Init_cocoa(void)
{
    rb_cApplication = rb_define_class("Application", rb_cObject);
    rb_define_method(rb_cApplication, "initialize", application_initialize, 0);
    rb_define_method(rb_cApplication, "title=", application_title, 1);
    rb_define_method(rb_cApplication, "photo_paths=", application_photo_paths, 1);
    rb_define_method(rb_cApplication, "interval=", application_interval, 1);
    rb_define_method(rb_cApplication, "run", application_run, 0);
}
 
