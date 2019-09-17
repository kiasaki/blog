run:
	hugo serve --bind 0.0.0.0 -b http://localhost:1313

build:
	hugo

deps:
	go get github.com/gohugoio/hugo
