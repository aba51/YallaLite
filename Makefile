THEOS ?= /Users/runner/theos

ARCHS = arm64
TARGET := iphone:clang:latest:14.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YallaLite

YallaLite_FILES = Tweak.x
YallaLite_CFLAGS = -fobjc-arc
YallaLite_FRAMEWORKS = UIKit
YallaLite_EXTRA_FRAMEWORKS = FLEX3Framework
YallaLite_LDFLAGS = -F$(CURDIR)/flexlist/Library/Frameworks

include $(THEOS_MAKE_PATH)/tweak.mk
