#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// استدعاء خارجي لأداة فليكس إذا كانت متوفرة
extern void FlexInjectedInitialize(void) __attribute__((weak_import));

@interface SkullFloatingButton : UIButton
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, weak) UIViewController *currentVC;
@end

@implementation SkullFloatingButton

- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)vc {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentVC = vc;
        [self setTitle:@"💀" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:28];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.layer.cornerRadius = frame.size.width / 2;
        self.clipsToBounds = YES;
        
        // إيماءة السحب لتحريك الزر
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:self.panGesture];
        
        // إيماءة الضغط المزدوج لتفعيل الميزات
        self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        self.doubleTapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:self.doubleTapGesture];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    CGPoint newCenter = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    CGRect boundary = self.superview.bounds;
    newCenter.x = MAX(self.frame.size.width/2, MIN(boundary.size.width - self.frame.size.width/2, newCenter.x));
    newCenter.y = MAX(self.frame.size.height/2, MIN(boundary.size.height - self.frame.size.height/2, newCenter.y));
    self.center = newCenter;
    [gesture setTranslation:CGPointZero inView:self.superview];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
    // تشغيل فليكس عند الضغط المزدوج
    if (FlexInjectedInitialize != NULL) {
        FlexInjectedInitialize();
    }
    
    // البحث عن كلاس الكاميرا/المايك وتفكيكه في الخلفية لمنع الكراش
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            Class faceClass = NSClassFromString(@"YallaLite.LTLiveMikeFace");
            if (faceClass) {
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                [self findAndDestructFaceView:keyWindow targetClass:faceClass];
            }
        } @catch (NSException *exception) {}
    });
}

- (void)findAndDestructFaceView:(UIView *)subview targetClass:(Class)targetClass {
    if ([subview isKindOfClass:targetClass]) {
        SEL destructSelector = NSSelectorFromString(@".cxx_destruct");
        if ([subview respondsToSelector:destructSelector]) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [subview performSelector:destructSelector];
            #pragma clang diagnostic pop
        }
        return;
    }
    for (UIView *childView in subview.subviews) {
        [self findAndDestructFaceView:childView targetClass:targetClass];
    }
}
@end

static void (*orig_viewDidLoad)(UIViewController *self, SEL _cmd);

static void hooked_viewDidLoad(UIViewController *self, SEL _cmd) {
    orig_viewDidLoad(self, _cmd);
    
    // حقن زر الجمجمة العائم داخل الواجهة إذا لم يكن موجوداً مسبقاً
    if (![self.view viewWithTag:999]) {
        SkullFloatingButton *skullBtn = [[SkullFloatingButton alloc] initWithFrame:CGRectMake(20, 150, 55, 55) viewController:self];
        skullBtn.tag = 999;
        [self.view addSubview:skullBtn];
    }
}

// دالة الهوك الأساسية عند تشغيل التطبيق
__attribute__((constructor)) static void initialize_skull_tweak() {
    Class targetClass = NSClassFromString(@"UIViewController");
    SEL targetSelector = @selector(viewDidLoad);


Method originalMethod = class_getInstanceMethod(targetClass, targetSelector);
    
    if (originalMethod) {
        orig_viewDidLoad = (void *)method_getImplementation(originalMethod);
        method_setImplementation(originalMethod, (IMP)hooked_viewDidLoad);
    }
}
