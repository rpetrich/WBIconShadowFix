TWEAK_NAME = WBIconShadowFix
WBIconShadowFix_OBJC_FILES = WBIconShadowFix.m
WBIconShadowFix_FRAMEWORKS = Foundation UIKit

ADDITIONAL_CFLAGS = -std=c99

include framework/makefiles/common.mk
include framework/makefiles/tweak.mk
