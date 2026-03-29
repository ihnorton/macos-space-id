BINARY  = .build/release/SpaceID
APP     = SpaceID.app
BUNDLE  = $(APP)/Contents
MACOS   = $(BUNDLE)/MacOS

.PHONY: build bundle sign install run clean

build:
	swift build -c release

bundle: build
	mkdir -p $(MACOS)
	cp $(BINARY) $(MACOS)/SpaceID
	cp Info.plist $(BUNDLE)/Info.plist

sign: bundle
	/usr/bin/codesign --force --sign - $(APP)

install: sign
	mkdir -p ~/Applications
	rm -rf ~/Applications/$(APP)
	cp -R $(APP) ~/Applications/$(APP)

run: sign
	# Kill any existing instance first
	pkill -x SpaceID 2>/dev/null || true
	open $(APP)

clean:
	rm -rf .build $(APP)
