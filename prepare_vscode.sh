#!/usr/bin/env bash
# shellcheck disable=SC1091,2154

set -e

# Shiraki: the update feed is not set up yet, keep updates disabled unless explicitly enabled
DISABLE_UPDATE="${DISABLE_UPDATE:-yes}"

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  cp -rp src/insider/* vscode/
else
  cp -rp src/stable/* vscode/
fi

cp -f LICENSE vscode/LICENSE.txt

cd vscode || { echo "'vscode' dir not found"; exit 1; }

{ set +x; } 2>/dev/null

# {{{ product.json
cp product.json{,.bak}

setpath() {
  local jsonTmp
  { set +x; } 2>/dev/null
  jsonTmp=$( jq --arg 'value' "${3}" "setpath(path(.${2}); \$value)" "${1}.json" )
  echo "${jsonTmp}" > "${1}.json"
  set -x
}

setpath_json() {
  local jsonTmp
  { set +x; } 2>/dev/null
  jsonTmp=$( jq --argjson 'value' "${3}" "setpath(path(.${2}); \$value)" "${1}.json" )
  echo "${jsonTmp}" > "${1}.json"
  set -x
}

setpath "product" "checksumFailMoreInfoUrl" "https://go.microsoft.com/fwlink/?LinkId=828886"
setpath "product" "documentationUrl" "https://go.microsoft.com/fwlink/?LinkID=533484#vscode"
setpath_json "product" "extensionsGallery" '{"serviceUrl": "https://open-vsx.org/vscode/gallery", "itemUrl": "https://open-vsx.org/vscode/item", "latestUrlTemplate": "https://open-vsx.org/vscode/gallery/{publisher}/{name}/latest", "controlUrl": "https://raw.githubusercontent.com/EclipseFdn/publish-extensions/refs/heads/master/extension-control/extensions.json"}'

setpath "product" "introductoryVideosUrl" "https://go.microsoft.com/fwlink/?linkid=832146"
setpath "product" "keyboardShortcutsUrlLinux" "https://go.microsoft.com/fwlink/?linkid=832144"
setpath "product" "keyboardShortcutsUrlMac" "https://go.microsoft.com/fwlink/?linkid=832143"
setpath "product" "keyboardShortcutsUrlWin" "https://go.microsoft.com/fwlink/?linkid=832145"
setpath "product" "licenseUrl" "https://github.com/VSCodium/vscodium/blob/master/LICENSE"
setpath_json "product" "linkProtectionTrustedDomains" '["https://open-vsx.org"]'
setpath "product" "releaseNotesUrl" "https://go.microsoft.com/fwlink/?LinkID=533483#vscode"
setpath "product" "reportIssueUrl" "https://github.com/VSCodium/vscodium/issues/new"
setpath "product" "requestFeatureUrl" "https://go.microsoft.com/fwlink/?LinkID=533482"
setpath "product" "tipsAndTricksUrl" "https://go.microsoft.com/fwlink/?linkid=852118"
setpath "product" "twitterUrl" "https://go.microsoft.com/fwlink/?LinkID=533687"

if [[ "${DISABLE_UPDATE}" != "yes" ]]; then
  setpath "product" "updateUrl" "https://raw.githubusercontent.com/VSCodium/versions/refs/heads/master"

  if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
    setpath "product" "downloadUrl" "https://github.com/VSCodium/vscodium-insiders/releases"
  else
    setpath "product" "downloadUrl" "https://github.com/VSCodium/vscodium/releases"
  fi

  # if [[ "${OS_NAME}" == "windows" ]]; then
  #   setpath_json "product" "win32VersionedUpdate" "true"
  # fi
fi

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  setpath "product" "nameShort" "VSCodium - Insiders"
  setpath "product" "nameLong" "VSCodium - Insiders"
  setpath "product" "applicationName" "codium-insiders"
  setpath "product" "dataFolderName" ".vscodium-insiders"
  setpath "product" "linuxIconName" "vscodium-insiders"
  setpath "product" "quality" "insider"
  setpath "product" "urlProtocol" "vscodium-insiders"
  setpath "product" "serverApplicationName" "codium-server-insiders"
  setpath "product" "serverDataFolderName" ".vscodium-server-insiders"
  setpath "product" "darwinBundleIdentifier" "com.vscodium.VSCodiumInsiders"
  setpath "product" "win32AppUserModelId" "VSCodium.VSCodiumInsiders"
  setpath "product" "win32DirName" "VSCodium Insiders"
  setpath "product" "win32MutexName" "vscodiuminsiders"
  setpath "product" "win32NameVersion" "VSCodium Insiders"
  setpath "product" "win32RegValueName" "VSCodiumInsiders"
  setpath "product" "win32ShellNameShort" "VSCodium Insiders"
  setpath "product" "win32AppId" "{{EF35BB36-FA7E-4BB9-B7DA-D1E09F2DA9C9}"
  setpath "product" "win32x64AppId" "{{B2E0DDB2-120E-4D34-9F7E-8C688FF839A2}"
  setpath "product" "win32arm64AppId" "{{44721278-64C6-4513-BC45-D48E07830599}"
  setpath "product" "win32UserAppId" "{{ED2E5618-3E7E-4888-BF3C-A6CCC84F586F}"
  setpath "product" "win32x64UserAppId" "{{20F79D0D-A9AC-4220-9A81-CE675FFB6B41}"
  setpath "product" "win32arm64UserAppId" "{{2E362F92-14EA-455A-9ABD-3E656BBBFE71}"
  setpath "product" "tunnelApplicationName" "codium-insiders-tunnel"
  setpath "product" "win32TunnelServiceMutex" "vscodiuminsiders-tunnelservice"
  setpath "product" "win32TunnelMutex" "vscodiuminsiders-tunnel"
  setpath "product" "win32ContextMenu.x64.clsid" "90AAD229-85FD-43A3-B82D-8598A88829CF"
  setpath "product" "win32ContextMenu.arm64.clsid" "7544C31C-BDBF-4DDF-B15E-F73A46D6723D"
else
  setpath "product" "nameShort" "VSCodium"
  setpath "product" "nameLong" "VSCodium"
  setpath "product" "applicationName" "codium"
  setpath "product" "linuxIconName" "vscodium"
  setpath "product" "quality" "stable"
  setpath "product" "urlProtocol" "vscodium"
  setpath "product" "serverApplicationName" "codium-server"
  setpath "product" "serverDataFolderName" ".vscodium-server"
  setpath "product" "darwinBundleIdentifier" "com.vscodium"
  setpath "product" "win32AppUserModelId" "VSCodium.VSCodium"
  setpath "product" "win32DirName" "VSCodium"
  setpath "product" "win32MutexName" "vscodium"
  setpath "product" "win32NameVersion" "VSCodium"
  setpath "product" "win32RegValueName" "VSCodium"
  setpath "product" "win32ShellNameShort" "VSCodium"
  setpath "product" "win32AppId" "{{763CBF88-25C6-4B10-952F-326AE657F16B}"
  setpath "product" "win32x64AppId" "{{88DA3577-054F-4CA1-8122-7D820494CFFB}"
  setpath "product" "win32arm64AppId" "{{67DEE444-3D04-4258-B92A-BC1F0FF2CAE4}"
  setpath "product" "win32UserAppId" "{{0FD05EB4-651E-4E78-A062-515204B47A3A}"
  setpath "product" "win32x64UserAppId" "{{2E1F05D1-C245-4562-81EE-28188DB6FD17}"
  setpath "product" "win32arm64UserAppId" "{{57FD70A5-1B8D-4875-9F40-C5553F094828}"
  setpath "product" "tunnelApplicationName" "codium-tunnel"
  setpath "product" "win32TunnelServiceMutex" "vscodium-tunnelservice"
  setpath "product" "win32TunnelMutex" "vscodium-tunnel"
  setpath "product" "win32ContextMenu.x64.clsid" "D910D5E6-B277-4F4A-BDC5-759A34EEE25D"
  setpath "product" "win32ContextMenu.arm64.clsid" "4852FC55-4A84-4EA1-9C86-D53BE3DF83C0"
fi

setpath_json "product" "tunnelApplicationConfig" '{}'

jsonTmp=$( jq -s '.[0] * .[1]' product.json ../product.json )
echo "${jsonTmp}" > product.json && unset jsonTmp

# Shiraki: drop Copilot-only entries that the merge above cannot remove
jsonTmp=$( jq 'del(.trustedExtensionAuthAccess)' product.json )
echo "${jsonTmp}" > product.json && unset jsonTmp

# Shiraki: bundle the Japanese language pack (Open VSX) as a built-in extension,
# with "VS Code" in its translations replaced by the product name and the
# vscode-loc MIT license added to it
SHIRAKI_LP_NAME="MS-CEINTL.vscode-language-pack-ja"
SHIRAKI_LP_VERSION="1.131.0"
SHIRAKI_LP_SHA256="fae5a90170d48121bd8fe246d7d8ecbdab5bf88f21a0d58c94a3cc3af8c0f601"
SHIRAKI_LP_DIR=".build/shiraki"
SHIRAKI_LP_ORIG="${SHIRAKI_LP_DIR}/${SHIRAKI_LP_NAME}-${SHIRAKI_LP_VERSION}.orig.vsix"
SHIRAKI_LP_VSIX="${SHIRAKI_LP_DIR}/${SHIRAKI_LP_NAME}-${SHIRAKI_LP_VERSION}.vsix"

shiraki_sha256() {
  if command -v sha256sum &> /dev/null; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

mkdir -p "${SHIRAKI_LP_DIR}"
curl -fsSL --retry 3 -o "${SHIRAKI_LP_ORIG}" "https://open-vsx.org/api/MS-CEINTL/vscode-language-pack-ja/${SHIRAKI_LP_VERSION}/file/${SHIRAKI_LP_NAME}-${SHIRAKI_LP_VERSION}.vsix"

if [[ "$( shiraki_sha256 "${SHIRAKI_LP_ORIG}" )" != "${SHIRAKI_LP_SHA256}" ]]; then
  echo "Checksum mismatch for ${SHIRAKI_LP_ORIG}" >&2
  exit 1
fi

rm -f "${SHIRAKI_LP_VSIX}"
python3 -I ../build/shiraki/build_language_pack.py "${SHIRAKI_LP_ORIG}" "${SHIRAKI_LP_VSIX}" "${APP_NAME:?APP_NAME is not set}" ../build/shiraki/language-pack-keep-vscode.json ../build/shiraki/language-pack-ja-LICENSE.md

jsonTmp=$( jq --arg name "${SHIRAKI_LP_NAME}" --arg version "${SHIRAKI_LP_VERSION}" --arg vsix "${SHIRAKI_LP_VSIX}" --arg sha256 "$( shiraki_sha256 "${SHIRAKI_LP_VSIX}" )" \
  '.builtInExtensions += [{
    "name": $name,
    "version": $version,
    "sha256": $sha256,
    "repo": "https://github.com/microsoft/vscode-loc",
    "vsix": $vsix,
    "metadata": {
      "id": "077515fe-1509-49c0-9dcc-5511b41682fc",
      "publisherId": {
        "publisherId": "0b0882c3-aee3-4d7c-b5f9-872f9be0a115",
        "publisherName": "MS-CEINTL",
        "displayName": "MS-CEINTL",
        "flags": ""
      },
      "publisherDisplayName": "MS-CEINTL"
    }
  }]' product.json )
echo "${jsonTmp}" > product.json && unset jsonTmp

# Shiraki: bundle Open Remote - SSH (Open VSX) as a built-in extension.
# The .vsix already contains its MIT license (extension/LICENSE.txt).
SHIRAKI_ORS_NAME="jeanp413.open-remote-ssh"
SHIRAKI_ORS_VERSION="0.4.0"
SHIRAKI_ORS_SHA256="4cf4d3720050eaf7e6299770593defa7c75ee2cd4c999c92e4aa6ce168b6634b"
SHIRAKI_ORS_VSIX="${SHIRAKI_LP_DIR}/${SHIRAKI_ORS_NAME}-${SHIRAKI_ORS_VERSION}.vsix"

curl -fsSL --retry 3 -o "${SHIRAKI_ORS_VSIX}" "https://open-vsx.org/api/jeanp413/open-remote-ssh/${SHIRAKI_ORS_VERSION}/file/${SHIRAKI_ORS_NAME}-${SHIRAKI_ORS_VERSION}.vsix"

if [[ "$( shiraki_sha256 "${SHIRAKI_ORS_VSIX}" )" != "${SHIRAKI_ORS_SHA256}" ]]; then
  echo "Checksum mismatch for ${SHIRAKI_ORS_VSIX}" >&2
  exit 1
fi

jsonTmp=$( jq --arg name "${SHIRAKI_ORS_NAME}" --arg version "${SHIRAKI_ORS_VERSION}" --arg vsix "${SHIRAKI_ORS_VSIX}" --arg sha256 "${SHIRAKI_ORS_SHA256}" \
  '.builtInExtensions += [{
    "name": $name,
    "version": $version,
    "sha256": $sha256,
    "repo": "https://github.com/jeanp413/open-remote-ssh",
    "vsix": $vsix,
    "metadata": {
      "id": "9fc16cea-08e2-4ae5-bf75-224004d722ff",
      "publisherId": {
        "publisherId": "82e59b79-acc5-4a5b-81cb-9303cbdc05cb",
        "publisherName": "jeanp413",
        "displayName": "jeanp413",
        "flags": ""
      },
      "publisherDisplayName": "jeanp413"
    }
  }]' product.json )
echo "${jsonTmp}" > product.json && unset jsonTmp

cat product.json
# }}}

# include common functions
. ../utils.sh

# {{{ apply patches

echo "APP_NAME=\"${APP_NAME}\""
echo "APP_NAME_LC=\"${APP_NAME_LC}\""
echo "ASSETS_REPOSITORY=\"${ASSETS_REPOSITORY}\""
echo "BINARY_NAME=\"${BINARY_NAME}\""
echo "GH_REPO_PATH=\"${GH_REPO_PATH}\""
echo "GLOBAL_DIRNAME=\"${GLOBAL_DIRNAME}\""
echo "ORG_NAME=\"${ORG_NAME}\""
echo "TUNNEL_APP_NAME=\"${TUNNEL_APP_NAME}\""

if [[ "${DISABLE_UPDATE}" == "yes" ]]; then
  apply_patch ../patches/00-update-disable.patch.yet
fi

for file in ../patches/*.json; do
  if [[ -f "${file}" ]]; then
    apply_actions "${file}"
  fi
done

for file in ../patches/*.patch; do
  if [[ -f "${file}" ]]; then
    apply_patch "${file}"
  fi
done

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  for file in ../patches/insider/*.patch; do
    if [[ -f "${file}" ]]; then
      apply_patch "${file}"
    fi
  done
fi

if [[ -d "../patches/${OS_NAME}/" ]]; then
  for file in "../patches/${OS_NAME}/"*.patch; do
    if [[ -f "${file}" ]]; then
      apply_patch "${file}"
    fi
  done
fi

for file in ../patches/user/*.patch; do
  if [[ -f "${file}" ]]; then
    apply_patch "${file}"
  fi
done

# Shiraki patches (kept apart from the VSCodium ones to ease upstream merges)
for file in ../patches/shiraki/*.patch; do
  if [[ -f "${file}" ]]; then
    apply_patch "${file}"
  fi
done
# }}}

set -x

# {{{ install dependencies
export ELECTRON_SKIP_BINARY_DOWNLOAD=1
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

if [[ "${OS_NAME}" == "linux" ]]; then
  export VSCODE_SKIP_NODE_VERSION_CHECK=1

  if [[ "${npm_config_arch}" == "arm" ]]; then
    export npm_config_arm_version=7
  fi
elif [[ "${OS_NAME}" == "windows" ]]; then
  if [[ "${npm_config_arch}" == "arm" ]]; then
    export npm_config_arm_version=7
  fi
else
  if [[ "${CI_BUILD}" != "no" ]]; then
    clang++ --version
  fi
fi

node build/npm/preinstall.ts

mv .npmrc .npmrc.bak
cp ../npmrc .npmrc

for i in {1..5}; do # try 5 times
  if [[ "${CI_BUILD}" != "no" && "${OS_NAME}" == "osx" ]]; then
    CXX=clang++ npm ci && break
  else
    npm ci && break
  fi

  if [[ $i == 5 ]]; then
    echo "Npm install failed too many times" >&2
    exit 1
  fi
  echo "Npm install failed $i, trying again..."

  sleep $(( 15 * (i + 1)))
done

mv .npmrc.bak .npmrc
# }}}

# package.json
cp package.json{,.bak}

setpath "package" "version" "${RELEASE_VERSION%-insider}"

replace 's|Microsoft Corporation|Yoshiro Moriyama|' package.json
replace "s|--max-old-space-size=8192|--max-old-space-size=${MAX_OLD_SPACE_SIZE}|" package.json

cp resources/server/manifest.json{,.bak}

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  setpath "resources/server/manifest" "name" "VSCodium - Insiders"
  setpath "resources/server/manifest" "short_name" "VSCodium - Insiders"
else
  setpath "resources/server/manifest" "name" "Shiraki"
  setpath "resources/server/manifest" "short_name" "Shiraki"
fi

# announcements
replace "s|\\[\\/\\* BUILTIN_ANNOUNCEMENTS \\*\\/\\]|$( tr -d '\n' < ../announcements-builtin.json )|" src/vs/workbench/contrib/welcomeGettingStarted/browser/gettingStarted.ts

../undo_telemetry.sh

replace 's|Microsoft Corporation|Shiraki|' build/lib/electron.ts
replace 's|([0-9]) Microsoft|\1 Shiraki|' build/lib/electron.ts

if [[ "${OS_NAME}" == "linux" ]]; then
  # microsoft adds their apt repo to sources
  # unless the app name is code-oss
  # as we are renaming the application to vscodium
  # we need to edit a line in the post install template
  if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
    sed -i "s/code-oss/codium-insiders/" resources/linux/debian/postinst.template
  else
    sed -i "s/code-oss/shiraki/" resources/linux/debian/postinst.template
  fi

  # fix the packages metadata
  # code.appdata.xml
  sed -i 's|Visual Studio Code|Shiraki|g' resources/linux/code.appdata.xml
  sed -i 's|https://code.visualstudio.com/docs/setup/linux|https://github.com/moriyama-dev/shiraki|' resources/linux/code.appdata.xml
  sed -i 's|https://code.visualstudio.com|https://github.com/moriyama-dev/shiraki|' resources/linux/code.appdata.xml

  # control.template
  sed -i 's|Microsoft Corporation <vscode-linux@microsoft.com>|Yoshiro Moriyama <7315004+moriyama-dev@users.noreply.github.com>|'  resources/linux/debian/control.template
  sed -i 's|Visual Studio Code|Shiraki|g' resources/linux/debian/control.template
  sed -i 's|https://code.visualstudio.com/docs/setup/linux|https://github.com/moriyama-dev/shiraki|' resources/linux/debian/control.template
  sed -i 's|https://code.visualstudio.com|https://github.com/moriyama-dev/shiraki|' resources/linux/debian/control.template
  # recommend CJK fonts so that the Japanese UI is rendered on systems without them
  sed -i 's|^Recommends: @@RECOMMENDS@@$|Recommends: @@RECOMMENDS@@, fonts-noto-cjk|' resources/linux/debian/control.template
  # replace the upstream description (it is the last field of the template)
  sed -i '/^Description:/,$d' resources/linux/debian/control.template
  cat >> resources/linux/debian/control.template <<'EOF'
Description: Shiraki is a lightweight, quiet code editor built on Code - OSS.
 Shiraki removes features you do not need and keeps only what helps you
 work with Claude. It is not affiliated with or endorsed by Microsoft or
 the VSCodium project.
EOF

  # code.spec.template
  sed -i 's|Microsoft Corporation|VSCodium Team|' resources/linux/rpm/code.spec.template
  sed -i 's|Visual Studio Code Team <vscode-linux@microsoft.com>|VSCodium Team https://github.com/VSCodium/vscodium/graphs/contributors|' resources/linux/rpm/code.spec.template
  sed -i 's|Visual Studio Code|VSCodium|' resources/linux/rpm/code.spec.template
  sed -i 's|https://code.visualstudio.com/docs/setup/linux|https://github.com/VSCodium/vscodium#download-install|' resources/linux/rpm/code.spec.template
  sed -i 's|https://code.visualstudio.com|https://vscodium.com|' resources/linux/rpm/code.spec.template

  # snapcraft.yaml
  sed -i 's|Visual Studio Code|VSCodium|' resources/linux/rpm/code.spec.template
elif [[ "${OS_NAME}" == "windows" ]]; then
  # code.iss
  sed -i 's|https://code.visualstudio.com|https://vscodium.com|' build/win32/code.iss
  sed -i 's|Microsoft Corporation|VSCodium|' build/win32/code.iss
fi

cd ..
