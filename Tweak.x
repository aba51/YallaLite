#import <UIKit/UIKit.h>

static NSTimer *micTimer = nil;
static UIButton *micButton = nil;
static BOOL micRunning = NO;

static UIWindow *YLKeyWindow() {
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) return window;
            }
        }
    }
    return nil;
}

static void MicTick() {
    NSLog(@"Mic-CXX tick");
    // هنا بعدين نحط أمر الضغط على زر المايك الحقيقي
}

static void ToggleMicCXX() {
    micRunning = !micRunning;

    if (micRunning) {
        [micButton setTitle:@"Mic-CXX ON" forState:UIControlStateNormal];
        micTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer *timer) {
            MicTick();
        }];
    } else {
        [micButton setTitle:@"Mic-CXX OFF" forState:UIControlStateNormal];
        [micTimer invalidate];
        micTimer = nil;
    }
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *window = YLKeyWindow();
        if (!window) return;

        micButton = [UIButton buttonWithType:UIButtonTypeSystem];
        micButton.frame = CGRectMake(20, 120, 130, 45);
        micButton.backgroundColor = [UIColor blackColor];
        [micButton setTitle:@"Mic-CXX OFF" forState:UIControlStateNormal];
        [micButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        micButton.layer.cornerRadius = 12;
        micButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];

        [micButton addAction:[UIAction actionWithHandler:^(__kindof UIAction *action) {
            ToggleMicCXX();
        }] forControlEvents:UIControlEventTouchUpInside];

      [window addSubview:micButton];
});
}
