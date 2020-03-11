//
//  WDFlutterRouteEventHandler.m
//  hybrid_router
//
//  Created by blackox626 on 2019/6/27.
//

#import "WDFlutterRouteEventHandler.h"
#import "WDFlutterRouter.h"
#import "WDFlutterViewContainerManager.h"
#import "WDFlutterViewContainer+FlutterPage.h"

@implementation WDFlutterRouteEventHandler

+ (WDFlutterViewContainer *)find:(NSString *)pageId {
    WDFlutterViewContainer *vc = (WDFlutterViewContainer *)[WD_FLUTTER_ENGINE flutterViewController];
    return vc.options.nativePageId == pageId ? vc : nil;
}

#pragma mark -- container page

+ (void)beforeNativePagePop:(NSString *)pageId result:(id)result {

    WDFlutterViewContainer *container = [self find:pageId];
    if(!container) {
        //[WD_FLUTTER_ENGINE detach];
        return;
    }
    
    //防止页面回退 异常
    //[container surfaceUpdated:NO];
    //[WD_FLUTTER_ENGINE detach];
    
    if ([container respondsToSelector:@selector(nativePageWillRemove:)]) {
        [container nativePageWillRemove:result];
    }
    
    if(container.options.modal) {
        [container dismissViewControllerAnimated:container.options.animated completion:nil];
    } else {
        UINavigationController *nav = container.navigationController;
        if (nav.topViewController == container) {
            if (nav.viewControllers.count == 1) {
                [nav dismissViewControllerAnimated:container.options.animated completion:nil];
            } else {
                [nav popViewControllerAnimated:container.options.animated];
            }
        } else {
            [self removeContainer:container];
        }
    }
}

+ (void)removeContainer:(WDFlutterViewContainer *)container {
    UINavigationController *nav = container.navigationController;
    if (!nav) return;
    NSMutableArray<UIViewController *> *viewControllers = nav.viewControllers.mutableCopy;
    [viewControllers removeObject:container];
    nav.viewControllers = viewControllers.copy;
}

+ (void)onNativePageRemoved:(NSString *)pageId result:(id)result {
    WDFlutterViewContainer *container = [self find:pageId];
    if (container && [container respondsToSelector:@selector(nativePageRemoved:)]) {
        [container nativePageRemoved:result];
    }
}

+ (void)onNativePageResume:(NSString *)pageId {
    WDFlutterViewContainer *container = [self find:pageId];
    if (container && [container respondsToSelector:@selector(nativePageResume)]) {
        [container nativePageResume];
    }
}

+ (void)onNativePageCreate:(NSString *)pageId {
    WDFlutterViewContainer *container = [self find:pageId];
    if (container && [container respondsToSelector:@selector(nativePageCreate)]) {
        [container nativePageCreate];
    }
}

+ (void)onNativePagePause:(NSString *)pageId {
    WDFlutterViewContainer *container = [self find:pageId];
    if (container && [container respondsToSelector:@selector(nativePagePause)]) {
        [container nativePagePause];
    }
}

#pragma mark -- flutter page

+ (void)onFlutterPagePushed:(NSString *)pageId name:(NSString *)name {
    WDFlutterViewContainer *controller = [self find:pageId];
    if (controller && [controller respondsToSelector:@selector(flutterPagePushed:)]) {
        [controller flutterPagePushed:name];
    }
}

+ (void)onFlutterPageRemoved:(NSString *)pageId name:(NSString *)name {
    WDFlutterViewContainer *controller = [self find:pageId];
    if (controller && [controller respondsToSelector:@selector(flutterPageRemoved:)]) {
        [controller flutterPageRemoved:name];
    }
}

+ (void)onFlutterPageResume:(NSString *)pageId name:(NSString *)name {
    WDFlutterViewContainer *controller = [self find:pageId];
    if (controller && [controller respondsToSelector:@selector(flutterPageResume:)]) {
        [controller flutterPageResume:name];
    }
}

+ (void)onFlutterPagePause:(NSString *)pageId name:(NSString *)name {
    WDFlutterViewContainer *controller = [self find:pageId];
    if (controller && [controller respondsToSelector:@selector(flutterPagePause:)]) {
        [controller flutterPagePause:name];
    }
}

@end
