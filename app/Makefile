.PHONY: build test

build:
	# generate code
	fvm dart run build_runner build
	# build proto
	@PATH="${PWD}/.flutter/bin:${PATH}" protoc \
		--dart_out=grpc:./lib/databox \
		-I../proto \
		../proto/databox.proto

test:
	fvm flutter test