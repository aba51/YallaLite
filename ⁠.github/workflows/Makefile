TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YallaLiteSkull

YallaLiteSkull_FILES = Tweak.x
YallaLiteSkull_FRAMEWORKS = UIKit CoreGraphics
YallaLiteSkull_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
