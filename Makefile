OUTPUT = change-input-source
BASEDIR := $(shell pwd)
all: clean build
build:
	mkdir -p build
	swiftc -Onone -v -o build/$(OUTPUT) *.swift

clean:
	rm -rf build

soft-link:
	ln -sf $(BASEDIR)/build/$(OUTPUT) /usr/local/bin/$(OUTPUT)
	ln -sf $(BASEDIR)/change-input-source-to-us /usr/local/bin/change-input-source-to-us

