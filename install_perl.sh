#!/bin/bash

# Script to install a custom version of Perl in the user's home directory

PERL_VERSION="5.40.2"
PERL_TARBALL="perl-${PERL_VERSION}.tar.gz"
PERL_URL="https://www.cpan.org/src/5.0/${PERL_TARBALL}"
INSTALL_DIR="$HOME/perl5"
WORKDIR="$HOME/workdir"

echo "Starting Perl installation script..."
echo "Installing Perl version: ${PERL_VERSION} to: ${INSTALL_DIR}"
echo "Downloading and working in directory: ${WORKDIR}"

# Create working directory if it doesn't exist
mkdir -p "${WORKDIR}"
cd "${WORKDIR}" || exit 1

# 1. Download Perl Source
echo -e "\n-- Downloading Perl source --"
if [ ! -f "${PERL_TARBALL}" ]; then
  echo "Downloading ${PERL_URL}..."
  wget "${PERL_URL}"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to download Perl source."
    exit 1
  fi
else
  echo "${PERL_TARBALL} already exists. Skipping download."
fi

# 2. Extract Perl Source
echo -e "\n-- Extracting Perl source --"
if [ -d "perl-${PERL_VERSION}" ]; then
  echo "Perl source directory already exists. Skipping extraction."
else
  echo "Extracting ${PERL_TARBALL}..."
  tar -xzf "${PERL_TARBALL}"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to extract Perl source."
    exit 1
  fi
fi

# 3. Configure the Build
echo -e "\n-- Configuring the build --"
cd "perl-${PERL_VERSION}" || exit 1
echo "Running ./Configure -des -Dprefix=${INSTALL_DIR}"
./Configure -des -Dprefix="${INSTALL_DIR}"
if [ $? -ne 0 ]; then
  echo "Error: Configuration failed. Check the config.log file for details."
  exit 1
fi

# 4. Build Perl
echo -e "\n-- Building Perl --"
echo "Running make"
make
if [ $? -ne 0 ]; then
  echo "Error: Build failed. Check the output above for errors."
  exit 1
fi

# 5. Install Perl
echo -e "\n-- Installing Perl --"
echo "Running make install"
make install
if [ $? -ne 0 ]; then
  echo "Error: Installation failed. Check the output above for errors."
  exit 1
fi

# 6. Set Up Environment Variables
echo -e "\n-- Setting up environment variables --"
SHELL_CONFIG=""
case "$SHELL" in
  *bash*)
    SHELL_CONFIG="$HOME/.bashrc"
    ;;
  *zsh*)
    SHELL_CONFIG="$HOME/.zshrc"
    ;;
  *)
    echo "Warning: Your shell (${SHELL}) is not automatically supported for environment variable setup."
    echo "Please manually add the following lines to your shell configuration file:"
    echo "  export PATH=\"${INSTALL_DIR}/bin:\$PATH\""
    echo "  export PERL5LIB=\"${INSTALL_DIR}/lib/perl5\""
    echo "  export PERL_LOCAL_LIB_ROOT=\"${INSTALL_DIR}\""
    exit 0
    ;;
esac

if grep -q "export PATH=\"${INSTALL_DIR}/bin:\$PATH\"" "${SHELL_CONFIG}"; then
  echo "Environment variables already present in ${SHELL_CONFIG}."
else
  echo "Adding environment variables to ${SHELL_CONFIG}"
  cat >> "${SHELL_CONFIG}" <<EOL
export PATH="${INSTALL_DIR}/bin:\$PATH"
export PERL5LIB="${INSTALL_DIR}/lib/perl5"
export PERL_LOCAL_LIB_ROOT="${INSTALL_DIR}"
EOL
  echo "Remember to source your shell configuration file (e.g., 'source ${SHELL_CONFIG}') to apply these changes."
fi

# 7. Install cpanm
echo -e "\n-- Installing cpanm --"
if [ ! -f "${INSTALL_DIR}/bin/cpanm" ]; then
  echo "Downloading and installing cpanm..."
  curl -L https://cpanmin.us | "${INSTALL_DIR}/bin/perl" - App::cpanminus
  if [ $? -ne 0 ]; then
    echo "Warning: Failed to install cpanm. You can install it manually later."
  fi
else
  echo "cpanm already installed in ${INSTALL_DIR}/bin."
fi

echo -e "\n-- Installation complete! --"
echo "Your custom Perl is installed in: ${INSTALL_DIR}"
echo "The downloaded files and build process occurred in: ${WORKDIR}"
echo "Make sure you have sourced your shell configuration file to use it."
echo "You can verify by running 'which perl' and 'perl -v'."

exit 0
