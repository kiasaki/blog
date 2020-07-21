run:
	hugo server -D

build:
	hugo

deploy: build
	aws s3 sync public s3://www.tulsidin.ca/ --delete
	aws cloudfront create-invalidation --distribution-id E1GHBUJ5KX95LV --paths '/*'

deps:
	wget https://github.com/gohugoio/hugo/releases/download/v0.74.2/hugo_0.74.2_Linux-64bit.tar.gz -O hugo.tar.gz
	tar -xzf hugo.tar.gz
	chmod +x hugo
	mv hugo ~/bin/
	rm hugo.tar.gz
