#!/bin/sh


while getopts "v:" Option
do
  case $Option in
    v ) KDE_VERSION=${OPTARG}
        ;;
  esac
done

if [ -z $KDE_VERSION ]; then
 echo "-v VERSION?"
 exit 1
fi


kdebase="kactivities \
	kde-baseapps \
	konsole \
	kate \
	kde-wallpapers \
	kde-workspace \
	kdebase-runtime \
	kde-base-artwork"

kdeedu="libkdeedu \
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
	rocs \
	step"

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

kdegraphics="libkipi \
	libkexiv2 \
	libkdcraw \
	libksane \
	okular \
	gwenview \
	kamera \
	kcolorchooser \
	kgamma \
	kolourpaint \
	kruler \
	ksaneplugin \
	ksnapshot \
	svgpart \
	mobipocket \
	kdegraphics-strigi-analyzer \
	kdegraphics-thumbnailers"

kdebindings="smokegen \
	smokeqt \
	qtruby \
	perlqt \
	smokekde \
	korundum \
	perlkde \
	pykde4 \
	kross-interpreters"

kdeaccessibility="jovie \
	kaccessible \
	kmag \
	kmousetool \
	kmouth"

kdeutils="ark \
	filelight \
	kcalc \
	kcharselect \
	kdf \
	kfloppy \
	kgpg \
	kremotecontrol \
	ktimer \
	kwallet \
	print-manager \
	superkaramba \
	sweeper"

DONE_MODLIST=""

kdemultimedia="libkcddb \
	libkcompactdisc \
	audiocd-kio \
	dragon \
	ffmpegthumbs \
	juk \
	kmix \
	kscd \
	mplayerthumbs"

# ? #
plasma_active="contour \
	plasma-active"
#####


MODLIST="kdelibs \
	kdepimlibs \
	nepomuk-core \
	nepomuk-widgets \
	analitza \
	$kdebase \
	kdesdk \
	$kdegraphics \
	$kdebindings \
	kde-workspace \
	${kdeaccessibility} \
	$kdeutils \
	$kdemultimedia \
	kdenetwork \
	oxygen-icons \
	kdeadmin \
	kdeartwork \
	$kdegames \
	kdetoys \
	kdepim \
	kdepim-runtime \
	$kdeedu \
	kdewebdev \
	kdeplasma-addons \
	kde-l10n-ru \
	kde-l10n-uk"


RESULT="DONE"
CWD=`pwd`
ARCH="`uname -m`"
DIRKA="$CWD/../kde-$KDE_VERSION/$ARCH"
#LOGFILE="$CWD/kde-$KDE_VERSION-build.log"
LOGFILE="$DIRKA/../_kde-$KDE_VERSION-$ARCH-build.log"


if [ ! -d "$DIRKA" ]; then
	mkdir -p $DIRKA
fi


# META
a_kde (){
A="kdegraphics kdebindings kdeaccessibility kdeutils kdemultimedia kdegames kdeedu"
for a in $A ; do
( cd ./ALL/$a
if mkpkg -bv $KDE_VERSION -bb 1 -pod ${DIRKA}/../meta ; then
 if [ ! -d "${DIRKA}/../meta" ]; then
 mkdir -p ${DIRKA}/../meta
 fi
 if [[ "$a" == "kdebase" ]]; then D="$kdebase" ;
 elif [[ "$a" == "kdegraphics" ]]; then D="$kdegraphics" ;
 elif [[ "$a" == "kdebindings" ]]; then D="$kdebindings" ;
 elif [[ "$a" == "kdeaccessibility" ]]; then D="$kdeaccessibility" ;
 elif [[ "$a" == "kdemultimedia" ]]; then D="$kdemultimedia" ;
 elif [[ "$a" == "kdegames" ]]; then D="$kdegames" ;
 elif [[ "$a" == "kdeedu" ]]; then D="$kdeedu" ;
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


# K
b_kde (){

#DIRSRC="$CWD/../sources/kde-$KDE_VERSION"
#if [ ! -d "$DIRSRC" ]; then
#	mkdir -p $DIRSRC
#fi


echo "Building kde-$KDE_VERSION-$ARCH" > $LOGFILE
echo "--------------------------" >> $LOGFILE


# add deps and build_deps
mpkg-install qt4 soprano akonadi sip speech-dispatcher libassuan PyQt -y


# Your_NAME	ALL=(ALL) NOPASSWD: /usr/bin/mpkg
for i in $MODLIST ; do
	#mkpkg -si -bt api:$i -bv $KDE_VERSION -bb 1 || exit 1
	# Using local ABUILDS: version bump here

	#echo "Building $i" >> $LOGFILE

	( cd $i
		if mkpkg \
			-si -bv $KDE_VERSION -bb 1 \
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

e_kde(){
if [[ "$RESULT" != "ERROR" ]]; then
 #m_kde
 if [[ ! -d "${DIRKA}/../noarch" ]]; then
  mkdir -p ${DIRKA}/../noarch
 fi
 find ${DIRKA} -name "*noarch*.txz" \
	 -exec mv -v {} ${DIRKA}/../noarch ";" \
 || rmdir ${DIRKA}/../noarch
else
 echo "something wrong"
fi
}


# Build-build
#a_kde
b_kde
e_kde
