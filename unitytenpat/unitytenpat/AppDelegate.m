//
//  AppDelegate.m
//  unitytenpat
//
//  Created by feng ting on 2024/7/1.
//

#import "AppDelegate.h"
/* UnityFrameworkLoad */
UIKIT_STATIC_INLINE UnityFramework* UnityFrameworkLoad()
{
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];

    NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
    if ([bundle isLoaded] == false) [bundle load];

    UnityFramework* ufw = [bundle.principalClass getInstance];
    if (![ufw appController])
    {
        // unity is not initialized
        [ufw setExecuteHeader: &_mh_execute_header];
    }
    return ufw;
}
@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initUnity];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:launchOptions forKey:@"launchOptions"];
    [userDefaults synchronize];
    
    return YES;
}


#pragma mark - Unity

- (BOOL)unityIsInitialized
{
    return [self ufw] && [[self ufw] appController];
}

- (void)initUnity
{
    /* 判断Unity 是否已经初始化 */
    if ([self unityIsInitialized]) return;
    /* 初始化Unity */
    self.ufw = UnityFrameworkLoad();
    [self.ufw setDataBundleId:"com.unity3d.framework"];
    [self.ufw registerFrameworkListener:self];
//    [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
    
    NSString *argvStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"argv"];
    char **argv;
    sscanf([argvStr cStringUsingEncoding:NSUTF8StringEncoding], "%p",&argv);
    int argc = [[[NSUserDefaults standardUserDefaults] valueForKey:@"argc"] intValue];
    NSDictionary *launchOptions = [[NSUserDefaults standardUserDefaults] valueForKey:@"launchOptions"];
    [self.ufw runEmbeddedWithArgc:argc argv:argv appLaunchOpts:launchOptions];
    
}

- (void)showUnityView
{
    if (![self unityIsInitialized]){
        NSLog(@"Unity 还未初始化");
    }
    
    [self.ufw showUnityWindow];
}


- (void)showNativeView
{
    [self.window makeKeyAndVisible];
}

#pragma mark - UnityFrameworkListener
- (void)unityDidUnload:(NSNotification *)notification
{
    NSLog(@"========== %s ============",__func__);
    [self.window makeKeyAndVisible];
    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
}

- (void)unityDidQuit:(NSNotification *)notification
{
    NSLog(@"========== %s ============",__func__);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [[[self ufw] appController] applicationWillResignActive: application];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[[self ufw] appController] applicationDidEnterBackground: application];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[[self ufw] appController] applicationWillEnterForeground: application];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[[self ufw] appController] applicationDidBecomeActive: application];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    [[[self ufw] appController] applicationWillTerminate: application];
}

@end





