#/bin/sh

TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
MAJMIN=`echo $TAG | cut -d . -f 1,2 `
DIR="alpine-homeassistant"

echo $TAG
echo $MAJMIN

NBARCH=`manifest-tool inspect seblucas/$dir:$TAG | grep "Arch:" | wc -l`
if [[ $NBARCH -gt 1 ]]; then
  echo "Image seblucas/$dir:$TAG already uptodate"
  exit 0
fi
docker build . -t seblucas/$dir:$ARCH-$TAG -t seblucas/$dir:$MAJMIN
docker push seblucas/$dir:$ARCH-$TAG
if [[ $ARCH == "armhf" ]]; then
  echo "Manifest uploading ..."
  sed -i "s|{image}|$dir|g" manifest.yaml
  sed -i "s|{tag}|$TAG|g" manifest.yaml
  sed -i "s|{majmin}|$MAJMIN|g" manifest.yaml
  manifest-tool push from-spec manifest.yaml
  git checkout manifest.yaml
fi
