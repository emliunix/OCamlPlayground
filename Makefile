all: play interp

.PHONY: all

play: build_play exec_play

build_play:
	jbuilder build play

exec_play:
	jbuilder exec play

.PHONY: play build_play exec_play

interp: build_interp exec_interp

build_interp:
	jbuilder build interp

exec_interp:
	jbuilder exec test_main

.PHONY: interp build_interp exec_interp
