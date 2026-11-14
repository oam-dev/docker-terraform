#!/bin/sh
# retrieve_tf_provider.sh GROUP NAME VERSION
# Downloads a provider from releases.hashicorp.com for this image's architecture, checks it against
# the release's SHA256SUMS, and puts it in OpenTofu's implied local mirror (~/.terraform.d/plugins),
# so `tofu init` uses it without downloading. OpenTofu resolves provider addresses such as
# hashicorp/random on registry.opentofu.org, so that is the host directory.
set -eu

PROVIDER_GROUP=$1
PROVIDER_NAME=$2
PROVIDER_VERSION=$3
ARCH="${TARGETARCH:-$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/')}"

echo "Downloading: $PROVIDER_GROUP/$PROVIDER_NAME $PROVIDER_VERSION linux_$ARCH"

RELEASE_URL=https://releases.hashicorp.com/terraform-provider-$PROVIDER_NAME/$PROVIDER_VERSION
ZIP=terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_linux_${ARCH}.zip
PLUGIN_DIR=/root/.terraform.d/plugins/registry.opentofu.org/$PROVIDER_GROUP/$PROVIDER_NAME/$PROVIDER_VERSION/linux_$ARCH
WORK=$(mktemp -d)

cd "$WORK"
wget -q "$RELEASE_URL/$ZIP"
wget -q "$RELEASE_URL/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_SHA256SUMS"
grep " $ZIP\$" "terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_SHA256SUMS" | sha256sum -c -
mkdir -p "$PLUGIN_DIR"
unzip -o -q "$ZIP" -d "$PLUGIN_DIR"
chmod +x "$PLUGIN_DIR"/terraform-provider-"$PROVIDER_NAME"_*
cd /
rm -rf "$WORK"
