.PHONY: build test

build:
	# generate code
	fvm dart run build_runner build
	# generate lang
	fvm flutter gen-l10n
	# build proto
	@PATH="${PWD}/.flutter/bin:${PATH}" protoc \
		--dart_out=grpc:./lib/databox \
		-I../proto \
		../proto/databox.proto

test:
	fvm flutter test

clean:
	fvm flutter clean
	# remove secrets
	secret-tool clear account com.mayflypass.mayflypass.secureStorage