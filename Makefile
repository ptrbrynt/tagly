# Local release automation for Tagly.
#
# Credentials never live in this repo:
#   - asc stores its App Store Connect API key in the macOS Keychain (`asc auth login`).
#   - playconsole-cli stores its service-account profile in ~/.playconsole-cli/.
# Per-machine settings go in release.local.mk (gitignored); see release.local.mk.example.

-include release.local.mk

FLUTTER ?= fvm flutter
BUILD_FLAGS := --release --obfuscate

BUNDLE_ID ?= com.ptrbrynt.tagly
PACKAGE_NAME ?= com.ptrbrynt.tagly

ASC_APP_ID ?=
ASC_PROFILE ?=
TESTFLIGHT_GROUPS ?=
GPC_PROFILE ?=
PLAY_TRACK ?= internal
PLAY_ROLLOUT ?= 100

VERSION := $(shell sed -n 's/^version: *\([^+]*\)+.*/\1/p' pubspec.yaml)
BUILD_NUMBER := $(shell sed -n 's/^version: *[^+]*+\(.*\)/\1/p' pubspec.yaml)

IPA_DIR := build/ios/ipa
AAB := build/app/outputs/bundle/release/app-release.aab

ASC := asc $(if $(ASC_PROFILE),--profile $(ASC_PROFILE))
GPC := playconsole-cli --package $(PACKAGE_NAME) $(if $(GPC_PROFILE),--profile $(GPC_PROFILE))

.DEFAULT_GOAL := help
.PHONY: help doctor check-ios check-android \
	ios-build ios-testflight ios-submit \
	android-build android-upload \
	build release clean-release

help:
	@echo "Tagly $(VERSION)+$(BUILD_NUMBER)"
	@echo ""
	@echo "  make doctor           Check tools, credentials and local config"
	@echo "  make ios-build        Build a signed IPA"
	@echo "  make ios-testflight   Build and upload to TestFlight"
	@echo "  make ios-submit       Build, upload and submit for App Store review"
	@echo "  make android-build    Build a signed app bundle"
	@echo "  make android-upload   Build and upload to Play (PLAY_TRACK=$(PLAY_TRACK))"
	@echo "  make build            Build both platforms"
	@echo "  make release          TestFlight + Play $(PLAY_TRACK) upload"
	@echo ""
	@echo "Add DRY_RUN=1 to preview uploads without sending anything."

doctor:
	@command -v fvm >/dev/null || { echo "fvm not found"; exit 1; }
	@command -v asc >/dev/null || { echo "asc not found"; exit 1; }
	@command -v playconsole-cli >/dev/null || { echo "playconsole-cli not found"; exit 1; }
	$(ASC) auth doctor
	$(GPC) doctor

check-ios:
	@test -n "$(ASC_APP_ID)" || { echo "Set ASC_APP_ID in release.local.mk"; exit 1; }

check-android:
	@test -f android/key.properties || { echo "Missing android/key.properties (upload keystore config)"; exit 1; }

ios-build:
	$(FLUTTER) build ipa $(BUILD_FLAGS) --split-debug-info=out/ios --export-method app-store

ios-testflight: check-ios ios-build
	$(ASC) publish testflight \
		--app $(ASC_APP_ID) \
		--ipa "$$(ls $(IPA_DIR)/*.ipa | head -n 1)" \
		$(if $(TESTFLIGHT_GROUPS),--group "$(TESTFLIGHT_GROUPS)",--upload-only) \
		$(if $(DRY_RUN),--dry-run) \
		--wait

ios-submit: check-ios ios-build
	$(ASC) publish appstore \
		--app $(ASC_APP_ID) \
		--ipa "$$(ls $(IPA_DIR)/*.ipa | head -n 1)" \
		--version $(VERSION) \
		--wait \
		--submit $(if $(DRY_RUN),--dry-run,--confirm)

android-build: check-android
	$(FLUTTER) build appbundle $(BUILD_FLAGS) --split-debug-info=out/android

android-upload: android-build
	$(GPC) bundles upload \
		--file $(AAB) \
		--track $(PLAY_TRACK) \
		--rollout $(PLAY_ROLLOUT) \
		$(if $(DRY_RUN),--dry-run)

build: ios-build android-build

release: ios-testflight android-upload

clean-release:
	rm -rf $(IPA_DIR) build/app/outputs/bundle out
