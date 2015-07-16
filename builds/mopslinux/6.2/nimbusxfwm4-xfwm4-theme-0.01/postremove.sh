NAME=Nimbus-Xfwm4

# theme

THEMESET=$NAME
for theme in $THEMESET ;
do
	rm -rf /usr/share/themes/$theme ;
done
