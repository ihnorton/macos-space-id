BINARY        = .build/release/SpaceID
APP           = SpaceID.app
BUNDLE        = $(APP)/Contents
MACOS         = $(BUNDLE)/MacOS
LAUNCH_AGENTS = $(HOME)/Library/LaunchAgents
PLIST         = Sources/com.local.spaceid.plist
PLIST_NAME    = com.local.spaceid.plist

.PHONY: build bundle sign install run clean launchagent-install launchagent-uninstall

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

launchagent-install: install
	sed 's|__APP_PATH__|$(HOME)/Applications/$(APP)/Contents/MacOS/SpaceID|' \
		$(PLIST) > $(LAUNCH_AGENTS)/$(PLIST_NAME)
	launchctl load $(LAUNCH_AGENTS)/$(PLIST_NAME)
	@echo "SpaceID will now start automatically at login."

launchagent-uninstall:
	launchctl unload $(LAUNCH_AGENTS)/$(PLIST_NAME) 2>/dev/null || true
	rm -f $(LAUNCH_AGENTS)/$(PLIST_NAME)
	@echo "Launch agent removed."

clean:
	rm -rf .build $(APP)
