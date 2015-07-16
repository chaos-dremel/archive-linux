PRGNAM=nimbus

# icons & themes

ICONSET=$PRGNAM
for icons in $ICONSET ;
do
	rm -rf /usr/share/icons/$icons ;
done

THEMESET=$PRGNAM
for themes in $THEMESET ;
do
	rm -rf /usr/share/themes/*$themes ;
done
