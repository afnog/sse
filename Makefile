.PHONY: default clean gh-pages

default: gh-pages

clean:
	make -C master clean
	rm -rf generated

gh-pages: generated index.html

.PHONY: generated
generated:
	make -C master all
	rsync -a --delete master/output/ generated/

index.html: master/README.rst
	rst2html master/README.rst > index.html \
		--stylesheet-path=styles/html4css1.css,master/static/CharisSIL-4.112-web/web/CharisSIL-webfont-example.css \
		--link-stylesheet
