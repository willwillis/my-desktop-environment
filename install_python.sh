#!/bin/bash

# Script to install a custom version of Python in the user's home directory

PYTHON_VERSION="3.13.3"
PYTHON_TARBALL="Python-${PYTHON_VERSION}.tgz"
PYTHON_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/${PYTHON_TARBALL}"
INSTALL_DIR="$HOME/python3" # Changed to a version-less directory
WORKDIR="$HOME/workdir_python"

echo "Starting Python installation script..."
echo "Installing Python version: ${PYTHON_VERSION} to: ${INSTALL_DIR}"
echo "Downloading and working in directory: ${WORKDIR}"

# Create working directory if it doesn't exist
mkdir -p "${WORKDIR}"
cd "${WORKDIR}" || exit 1

# 1. Download Python Source
echo -e "\n-- Downloading Python source --"
if [ ! -f "${PYTHON_TARBALL}" ]; then
  echo "Downloading ${PYTHON_URL}..."
  wget "${PYTHON_URL}"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to download Python source."
    exit 1
  fi
else
  echo "${PYTHON_TARBALL} already exists. Skipping download."
fi

# 2. Extract Python Source
echo -e "\n-- Extracting Python source --"
if [ -d "Python-${PYTHON_VERSION}" ]; then
  echo "Python source directory already exists. Skipping extraction."
else
  echo "Extracting ${PYTHON_TARBALL}..."
  tar -xzf "${PYTHON_TARBALL}"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to extract Python source."
    exit 1
  fi
fi

# 3. Configure the Build
echo -e "\n-- Configuring the build --"
cd "Python-${PYTHON_VERSION}" || exit 1
echo "Running ./configure --enable-optimizations --enable-shared --prefix=${INSTALL_DIR}"
./configure --enable-optimizations --enable-shared --prefix="${INSTALL_DIR}"
if [ $? -ne 0 ]; then
  echo "Error: Configuration failed. Check the config.log file for details."
  exit 1
fi

# 4. Build Python
echo -e "\n-- Building Python --"
echo "Running make -j$(nproc)"
make -j$(nproc)
if [ $? -ne 0 ]; then
  echo "Error: Build failed. Check the output above for errors."
  exit 1
fi

# 5. Install Python
echo -e "\n-- Installing Python --"
echo "Running make install" # Changed back to make install for version-less executables
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
    echo "  export LD_LIBRARY_PATH=\"${INSTALL_DIR}/lib:\$LD_LIBRARY_PATH\""
    echo "Remember to source your shell configuration file (e.g., 'source ${SHELL_CONFIG}') to apply these changes."
    exit 0
    ;;
esac

if grep -q "export PATH=\"${INSTALL_DIR}/bin:\$PATH\"" "${SHELL_CONFIG}"; then
  echo "Environment variables for custom Python already present in ${SHELL_CONFIG}."
else
  echo "Adding environment variables for custom Python to ${SHELL_CONFIG}"
  cat >> "${SHELL_CONFIG}" <<EOL
export PATH="${INSTALL_DIR}/bin:\$PATH"
export LD_LIBRARY_PATH="${INSTALL_DIR}/lib:\$LD_LIBRARY_PATH"
EOL
  echo "Remember to source your shell configuration file (e.g., 'source ${SHELL_CONFIG}') to apply these changes."
fi

# 7. Verify Installation
echo -e "\n-- Installation complete! --"
echo "Your custom Python is installed in: ${INSTALL_DIR}"
echo "The downloaded files and build process occurred in: ${WORKDIR}"
echo "Verify by running 'python3 --version' and 'pip3 --version' (after updating pip)."
echo "You might need to run 'python3 -m pip install --upgrade pip' to get the latest pip."

# python3 -mvenv mypy
# alias mypy="source ~/mypy/bin/activate"

exit 0
