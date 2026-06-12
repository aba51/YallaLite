YallaLite_EXTRA_FRAMEWORKS = FLEX4Framework
YallaLite_FRAMEWORKS = UIKit
YallaLite_LDFLAGS = -F$(CURDIR)/flexlist/Library/Frameworks

ARCHS = arm64

TARGET := iphone:clang:latest:14.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YallaLite

YallaLite_FILES = Tweak.x

YallaLite_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
