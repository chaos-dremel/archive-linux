#!/bin/sh


while getopts "v:d:" Option
do
  case $Option in
    v ) KDE_VERSION=${OPTARG}
        ;;
    d ) KDE_PKG_DIR=${OPTARG}
        ;;
  esac
done

if [ -z $KDE_VERSION ]; then
 echo "-v VERSION?"
 exit 1
elif [ -z $KDE_PKG_DIR ]; then
 echo "-d KDE_PKG_DIR? and plz paths w/o ../ & ./"
 exit 1
fi


kdebase="nepomuk-core \
	nepomuk-widgets \
	kde-baseapps \
	kactivities \
	konsole \
	kate \
	kde-wallpapers \
	kde-workspace \
	kdebase-runtime \
	kde-base-artwork"

kdeedu="libkdeedu \
	analitza \
	blinken \
	cantor \
	kalgebra \
	kalzium \
	kanagram \
	kbruch \
	kgeography \
	khangman \
	kig \
	kiten \
	klettres \
	kmplot \
	kstars \
	ktouch \
	kturtle \
	kwordquiz \
	marble \
	parley \
	pairs \
	rocs \
	step"

kdegraphics="libkipi \
	libkexiv2 \
	libkdcraw \
	libksane \
	okular \
	mobipocket \
	kdegraphics-strigi-analyzer \
	kdegraphics-thumbnailers \
	gwenview \
	kamera \
	kcolorchooser \
	kgamma \
	kolourpaint \
	kruler \
	ksaneplugin \
	ksnapshot \
	svgpart"

kdebindings="smokegen \
	smokeqt \
	qtruby \
	perlqt \
	smokekde \
	korundum \
	perlkde \
	pykde4 \
	kross-interpreters" #qyoto kimono"

kdeaccessibility="jovie \
	kaccessible \
	kmousetool \
	kmouth \
	kmag"

kdeutils="ark \
	filelight \
	kcalc \
	kcharselect \
	kdf \
	kfloppy \
	kgpg \
	print-manager \
	kremotecontrol \
	ktimer \
	kwallet \
	superkaramba \
	sweeper"

DONE_MODLIST=""

kdemultimedia="libkcddb \
	libkcompactdisc \
	audiocd-kio \
	dragon \
	ffmpegthumbs \
	mplayerthumbs \
	juk \
	kmix \
	kscd"

# ? #
plasma_active="contour \
	plasma-active"
#####

kdei="kde-l10n-ru \
	kde-l10n-uk"


# since 4.10
kdegames="libkdegames \
	libkmahjongg \
	klickety \
	ksudoku \
	ksquares \
	kpat \
	klines \
	ksnakeduel \
	kollision \
	kshisen \
	kblocks \
	lskat \
	kreversi \
	bovo \
	kajongg \
	granatier \
	kmines \
	kiriki \
	kigo \
	bomber \
	kolf \
	kdiamond \
	kbounce \
	konquest \
	kapman \
	knavalbattle \
	killbots \
	kubrick \
	kgoldrunner \
	knetwalk \
	kbreakout \
	ksirk \
	kfourinline \
	picmi \
	kblackbox \
	palapeli \
	katomic \
	ktuberling \
	kjumpingcube \
	kmahjongg \
	kspaceduel"


# since 4.11
kdesdk="cervisia \
	dolphin-plugins \
	kapptemplate \
	kcachegrind \
	kde-dev-scripts \
	kde-dev-utils \
	kdesdk-kioslaves \
	kdesdk-strigi-analyzers \
	kdesdk-thumbnailers \
	kompare \
	lokalize \
	okteta \
	poxml \
	umbrello"

kdenetwork="kdenetwork-filesharing \
	kdenetwork-strigi-analyzers \
	kdnssd \
	kget \
	kopete \
	kppp \
	krdc \
	krfb"

kdeadmin="kcron \
	ksystemlog \
	kuser"

kdetoys="amor \
	kteatime \
	ktux"



MODLIST="\
	kdelibs \
	nepomuk-core \
	kdepimlibs \
	$kdebase \
	$kdesdk \
	$kdegraphics \
	$kdebindings \
	kde-workspace \
	$kdeaccessibility \
	$kdeutils \
	kdelibs \
	$kdemultimedia \
	$kdenetwork \
	oxygen-icons \
	$kdeadmin \
	kdeartwork \
	$kdegames \
	$kdetoys \
	kdepim \
	kdepim-runtime \
	$kdeedu \
	kdewebdev \
	kde-baseapps \
	kdeplasma-addons \
	$kdei"



CWD=`pwd`
ARCH="`uname -m`"

#DIRKA="$CWD/../kde-$KDE_VERSION/$ARCH"
DIRKA="$KDE_PKG_DIR/kde-$KDE_VERSION/$ARCH"

#LOGFILE="$CWD/kde-$KDE_VERSION-build.log"
LOGFILE="$DIRKA/../_kde-$KDE_VERSION-$ARCH-build.log"


if [ ! -d "$DIRKA" ]; then
	mkdir -p $DIRKA
fi


# K
b_kde (){

#DIRSRC="$CWD/../sources/kde-$KDE_VERSION"
#if [ ! -d "$DIRSRC" ]; then
#	mkdir -p $DIRSRC
#fi


if [ ! -f $LOGFILE ]; then
echo "Building kde-$KDE_VERSION-$ARCH" > $LOGFILE
fi
echo "--------------------------" >> $LOGFILE


# add deps and build_deps
mpkg-install qt4 soprano akonadi sip speech-dispatcher libassuan PyQt -y


# Your_NAME	ALL=(ALL) NOPASSWD: /usr/bin/mpkg
for i in $MODLIST ; do
	#mkpkg -si -bt api:$i -bv $KDE_VERSION -bb 1 || exit 1
	# Using local ABUILDS: version bump here

	#echo "Building $i" >> $LOGFILE

	( cd $i
		if mkpkg -si \
			-bb 1 \
			-bv $KDE_VERSION \
			-pod ${DIRKA} \
		; then
			#echo $i: SUCCESS >> $LOGFILE
			echo [x] $i >> $LOGFILE

		else
			#echo $i: FAILURE >> $LOGFILE
			exit 1
		fi
	)

	if [ $? -eq 1 ]; then
		RESULT="ERROR"
		echo [ ] $i: FAILURE >> $LOGFILE
		break
	#else
	#	echo "add $i"
 	#	ii="${i}>=${KDE_VERSION}"
 	#	echo "add $ii"
	#	sudo mpkg-setmeta ${DIRKA}/kde-${KDE_VERSION}-noarch-1.txz -d ${ii}
	fi

	#if mkpkg -si -bt api:$i -bv $KDE_VERSION -bb 1; then
	#	echo "$i: SUCCESS" >> $LOGFILE
	#else 
	#	echo "$i: FAILURE" >> $LOGFILE
	#fi

	RESULT="DONE"

done

echo "--------------------------" >> $LOGFILE
echo $RESULT >> $LOGFILE
}


# This is The End
m_kde(){
# Your_NAME	ALL=(ALL) NOPASSWD: /usr/bin/mpkg-setmeta
#  This metapackage includes all the official modules released
if [ -d kde ]; then
cd ./kde
mkpkg -bv $KDE_VERSION -bb 1 -pod ${DIRKA}
for i in $MODLIST ; do
 echo "add $i"
 ii="${i}>=${KDE_VERSION}"
 echo "add $ii"
 sudo mpkg-setmeta ${DIRKA}/kde-${KDE_VERSION}-noarch-1.txz --add-dep=${ii}
done
cd -
fi
}

# META
a_kde (){
A="kdegraphics kdebindings kdeaccessibility kdeutils kdemultimedia kdegames kdeedu"
for a in $A ; do
( cd ./ALL/$a
if mkpkg -bv $KDE_VERSION -bb 1 -pod ${DIRKA}/../meta ; then
 if [ ! -d "${DIRKA}/../meta" ]; then
  mkdir -p ${DIRKA}/../meta
 fi
 if 	[[ "$a" == "kdebase" 		]]; then D="$kdebase" ;
 elif 	[[ "$a" == "kdegraphics" 	]]; then D="$kdegraphics" ;
 elif 	[[ "$a" == "kdebindings" 	]]; then D="$kdebindings" ;
 elif 	[[ "$a" == "kdeaccessibility" 	]]; then D="$kdeaccessibility" ;
 elif 	[[ "$a" == "kdemultimedia" 	]]; then D="$kdemultimedia" ;
 elif 	[[ "$a" == "kdegames" 		]]; then D="$kdegames" ;
 elif 	[[ "$a" == "kdeedu" 		]]; then D="$kdeedu" ;
 fi
 for d in $D ; do
  echo "${d}>=${KDE_VERSION}"
  #mpkg-setmeta ${DIRKA}/../meta/${a}-$KDE_VERSION-noarch-1.txz --add-dep="${d}>=${KDE_VERSION}"
 done
fi
)
if [[ $? -eq 1 ]]; then
 break
#else
# touch /tmp/kde-$KDE_VERSION-meta-DONE
fi
done
}

e_kde(){
if [[ "$RESULT" != "ERROR" ]]; then
 #m_kde
 if [[ ! -d "$DIRKA/../noarch" ]]; then
  mkdir -p $DIRKA/../noarch
 fi
 find $DIRKA -name "*-noarch-*.txz" -exec mv -v {} $DIRKA/../noarch ";" || rmdir $DIRKA/../noarch
else
 echo "something wrong"
fi
}


# Build-build
#a_kde
b_kde
e_kde
