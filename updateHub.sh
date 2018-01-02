#/bin/sh

TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
MAJMIN=`echo $TAG | cut -d . -f 1,2 `

echo $TAG
echo $MAJMIN

NBARCH=`manifest-tool inspect seblucas/alpine-homeassistant:$TAG | grep "Arch:" | wc -l`
if [[ $NBARCH -gt 1 ]]; then
  echo "Image seblucas/$dir:$TAG already uptodate"
  continue
fi
docker build . -t seblucas/alpine-homeassistant:armv6-$TAG
docker push seblucas/alpine-homeassistant:armv6-$TAG
sed -i "s|{tag}|$TAG|g" manifest.yaml
sed -i "s|{majmin}|$MAJMIN|g" manifest.yaml
manifest-tool push from-spec manifest.yaml
git checkout manifest.yaml
