.PHONY: all clean

all:
	@sh scripts/build.sh MyFramework MyFramework

clean:
	@rm -rf build_* install

