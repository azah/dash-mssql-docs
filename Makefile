.PHONY: genhtml gendocs

genhtml:
	cd md-docs/docs/t-sql && fd . -e md -e JPG -e jpg -e PNG -e png -e GIF -e gif -c never -x ../../../convert.sh '{}'

gendocs:
	echo > log.txt
	echo > ms-sql.docset/Contents/Resources/docSet.dsidx
	cp Info.plist ms-sql.docset/Contents/Info.plist
	sh generate-docset.sh
	tar --exclude='.DS_Store' -cvzf ms-sql.tgz ms-sql.docset
