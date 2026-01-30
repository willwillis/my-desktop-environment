#!/bin/bash

# Script to install a custom version of Ruby in the user's home directory

RUBY_VERSION="3.4.7"
RUBY_TARBALL="ruby-${RUBY_VERSION}.tar.gz"
RUBY_URL="https://cache.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/${RUBY_TARBALL}"
INSTALL_DIR="$HOME/ruby3"
WORKDIR="$HOME/workdir_ruby"

echo "Starting Ruby installation script..."
echo "Installing Ruby version: ${RUBY_VERSION} to: ${INSTALL_DIR}"
echo "Downloading and working in directory: ${WORKDIR}"

# Create working directory if it doesn't exist
mkdir -p "${WORKDIR}"
cd "${WORKDIR}" || exit 1

# 1. Download Ruby Source
echo -e "\n-- Downloading Ruby source --"
if [ ! -f "${RUBY_TARBALL}" ]; then
  echo "Downloading ${RUBY_URL}..."
  wget "${RUBY_URL}"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to download Ruby source."
    exit 1
  fi
else
  echo "${RUBY_TARBALL} already exists. Skipping download."
fi

# 2. Extract Ruby Source
echo -e "\n-- Extracting Ruby source --"
if [ -d "ruby-${RUBY_VERSION}" ]; then
  echo "Ruby source directory already exists. Skipping extraction."
else
  echo "Extracting ${RUBY_TARBALL}..."
  tar -xzf "${RUBY_TARBALL}"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to extract Ruby source."
    exit 1
  fi
fi

# 3. Configure the Build
echo -e "\n-- Configuring the build --"
cd "ruby-${RUBY_VERSION}" || exit 1
echo "Running ./configure --prefix=${INSTALL_DIR} --disable-install-doc"
./configure --prefix="${INSTALL_DIR}" --disable-install-doc
if [ $? -ne 0 ]; then
  echo "Error: Configuration failed. Check the config.log file for details."
  exit 1
fi

# 4. Build Ruby
echo -e "\n-- Building Ruby --"
echo "Running make -j$(nproc)"
make -j$(nproc)
if [ $? -ne 0 ]; then
  echo "Error: Build failed. Check the output above for errors."
  exit 1
fi

# 5. Install Ruby
echo -e "\n-- Installing Ruby --"
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
    echo "  export GEM_HOME=\"${INSTALL_DIR}/lib/ruby/gems/${RUBY_VERSION%.*}.0\""
    echo "  export GEM_PATH=\"${INSTALL_DIR}/lib/ruby/gems/${RUBY_VERSION%.*}.0\""
    exit 0
    ;;
esac

if grep -q "export PATH=\"${INSTALL_DIR}/bin:\$PATH\"" "${SHELL_CONFIG}"; then
  echo "Environment variables for custom Ruby already present in ${SHELL_CONFIG}."
else
  echo "Adding environment variables for custom Ruby to ${SHELL_CONFIG}"
  cat >> "${SHELL_CONFIG}" <<EOL
export PATH="${INSTALL_DIR}/bin:\$PATH"
export GEM_HOME="${INSTALL_DIR}/lib/ruby/gems/${RUBY_VERSION%.*}.0"
export GEM_PATH="${INSTALL_DIR}/lib/ruby/gems/${RUBY_VERSION%.*}.0"
EOL
  echo "Remember to source your shell configuration file (e.g., 'source ${SHELL_CONFIG}') to apply these changes."
fi

# 7. Install bundler
echo -e "\n-- Installing bundler --"
if [ ! -f "${INSTALL_DIR}/bin/bundle" ]; then
  echo "Installing bundler..."
  "${INSTALL_DIR}/bin/gem" install bundler
  if [ $? -ne 0 ]; then
    echo "Warning: Failed to install bundler. You can install it manually later with 'gem install bundler'."
  fi
else
  echo "bundler already installed in ${INSTALL_DIR}/bin."
fi

echo -e "\n-- Installation complete! --"
echo "Your custom Ruby is installed in: ${INSTALL_DIR}"
echo "The downloaded files and build process occurred in: ${WORKDIR}"
echo "Make sure you have sourced your shell configuration file to use it."
echo "You can verify by running 'which ruby' and 'ruby -v'."
echo "Run 'gem install bundler' if you need the bundler gem for dependency management."

exit 0
