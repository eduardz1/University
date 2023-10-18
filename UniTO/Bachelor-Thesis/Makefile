in := main.typ
out := $(in:.typ=.pdf)

build: $(out)
	typst compile $(in)

watch: $(out)
	typst watch $(in)

clean:
	rm -f $(out)