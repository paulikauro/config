curl -X GET -o $1.$2.zip https://$1.gallery.vsassets.io/_apis/public/gallery/publisher/$1/extension/$2/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage
nix-hash --flat --base32 --type sha256 $1.$2.zip
jq -r '.version' <(unzip -qc "$1.$2.zip" "extension/package.json")

