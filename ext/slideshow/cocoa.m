#import <ruby.h>
#import "AppDelegate.h"

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

    NSWindow *window = [[NSWindow alloc] initWithContentRect: NSMakeRect(400, 200, 800, 600)
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
 
