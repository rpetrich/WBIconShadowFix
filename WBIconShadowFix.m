#import <SpringBoard/SpringBoard.h>
#import <CaptainHook/CaptainHook.h>

#include <dlfcn.h>

static BOOL enabled;

#define kSettingsChangeNotification "ch.rpetri.wbiconshadowfix.settingschange"
#define kSettingsFilePath "/var/mobile/Library/Preferences/ch.rpetri.wbiconshadowfix.plist"

static void ReloadPreferences()
{
	[(SpringBoard *)[UIApplication sharedApplication] relaunchSpringBoard];
}

CHDeclareClass(SBIconLabel);

static void (*properDrawRect)(id self, SEL _cmd, CGRect rect);

CHOptimizedMethod(1, self, void, SBIconLabel, drawRect, CGRect, rect)
{
	if (enabled)
		properDrawRect(self, _cmd, rect);
	else
		CHSuper(1, SBIconLabel, drawRect, rect);
}

CHConstructor {
	CHLoadLateClass(SBIconLabel);
	properDrawRect = (void *)class_getMethodImplementation(CHClass(SBIconLabel), @selector(drawRect:));
	dlopen("/Library/MobileSubstrate/DynamicLibraries/WinterBoard.dylib", RTLD_LAZY);
	CHHook(1, SBIconLabel, drawRect);
	CHAutoreleasePoolForScope();
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@kSettingsFilePath];
	enabled = [[dict objectForKey:@"enabled"] ?: (id)kCFBooleanTrue boolValue];
	[dict release];
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (void *)ReloadPreferences, CFSTR(kSettingsChangeNotification), NULL, CFNotificationSuspensionBehaviorHold);
}