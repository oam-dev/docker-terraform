set -x
# accept two arguments from command line
# 1. the group of the Terraform provider
# 2. the name of the Terraform provider
# 3. the version of the Terraform provider

PROVIDER_GROUP=$1
PROVIDER_NAME=$2
PROVIDER_VERSION=$3

echo "Downloading: $PROVIDER_NAME, $PROVIDER_VERSION"

TERRAFORM_DIR=/root/.terraform.d/plugins/registry.terraform.io/$PROVIDER_GROUP
HASHICORP_RELEASE_DOMAIN=https://releases.hashicorp.com

PROVIDER_RUL=$HASHICORP_RELEASE_DOMAIN/terraform-provider-"$PROVIDER_NAME"/"$PROVIDER_VERSION"/terraform-provider-"$PROVIDER_NAME"_"$PROVIDER_VERSION"_linux_amd64.zip
wget "$PROVIDER_RUL" -O provider.zip &&
  unzip provider.zip &&
  chmod +x terraform-provider-"$PROVIDER_NAME"_* &&
  mkdir -p $TERRAFORM_DIR/"$PROVIDER_NAME"/"$PROVIDER_VERSION"/linux_amd64 &&
  mv terraform-provider-"$PROVIDER_NAME"_* $TERRAFORM_DIR/"$PROVIDER_NAME"/"$PROVIDER_VERSION"/linux_amd64 &&
  rm -f provider.zip