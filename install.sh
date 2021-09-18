#!/usr/bin/env bash
set -euo pipefail

TFENV_VERSION=${TFENV_VERSION:-2.2.2}
TGENV_VERSION=${TGENV_VERSION:-0.1.0}

GITHUB_WORKSPACE=${GITHUB_WORKSPACE:-$(pwd)}
GITHUB_PATH=${GITHUB_PATH:-${GITHUB_WORKSPACE}/.github_path}

TOOLS_INSTALLDIR="${GITHUB_WORKSPACE}/.aws-terraform-tools"
TOOLS_BINDIR="${TOOLS_INSTALLDIR}/bin"
TFENV_INSTALLDIR="${TOOLS_INSTALLDIR}/tfenv"
TGENV_INSTALLDIR="${TOOLS_INSTALLDIR}/tgenv"

mkdir -p "${TOOLS_INSTALLDIR}" "${TOOLS_BINDIR}" "${TFENV_INSTALLDIR}" "${TGENV_INSTALLDIR}"

export PATH="${TOOLS_BINDIR}:${PATH}"

function create_symlinks {
  local SRC DST
  for SRC in "${@}"; do
    DST="${TOOLS_BINDIR}/$(basename "${SRC}")"
    [ -e "${DST}" ] || ln -s "${SRC}" "${DST}"
  done;
}

#
# Install tfenv and link binaries
#
echo "Install tfenv ${TFENV_VERSION}"
curl -L "https://github.com/tfutils/tfenv/archive/v${TFENV_VERSION}.tar.gz" | tar -xz -C "${TFENV_INSTALLDIR}" --strip 1
echo 'trust-tfenv: yes' > "${TFENV_INSTALLDIR}/use-gpgv"
create_symlinks "${TFENV_INSTALLDIR}/bin/terraform" "${TFENV_INSTALLDIR}/bin/tfenv"

#
# Install latest terraform via tfenv and use it as default
#
echo "Install latest terraform"
tfenv install
tfenv use

#
# Install tgenv and link binaries
#
echo "Install tgenv ${TGENV_VERSION}"
curl -L "https://github.com/taosmountain/tgenv/archive/refs/tags/${TGENV_VERSION}.tar.gz" | tar -xz -C "${TGENV_INSTALLDIR}" --strip 1
create_symlinks "${TGENV_INSTALLDIR}/bin/terragrunt" "${TGENV_INSTALLDIR}/bin/tgenv"

#
# Install latest terragrunt via tgenv and use it as default
#
echo "Install latest terragrunt"
tgenv install
tgenv use

# Add tools bindir to path
echo "${TOOLS_INSTALLDIR}/bin" >> "${GITHUB_PATH}"
