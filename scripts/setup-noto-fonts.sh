#!/bin/bash

# Noto Sans Mono Font Configuration Script
# Sets Noto Sans Mono as the default monospace font system-wide on Linux/bspwm

set -e

echo "🔤 Setting up Noto Sans Mono as default monospace font..."

# Check if Noto Sans Mono is installed
if ! fc-list | grep -q "Noto Sans Mono"; then
    echo "❌ Noto Sans Mono not found. Please install it first:"
    echo "   Arch/Manjaro: sudo pacman -S noto-fonts"
    echo "   Ubuntu/Debian: sudo apt install fonts-noto"
    exit 1
fi

echo "✅ Noto Sans Mono found"

# Create fontconfig directory
mkdir -p ~/.config/fontconfig

# Create fontconfig configuration
echo "📝 Creating fontconfig configuration..."
cat > ~/.config/fontconfig/fonts.conf << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Set Noto Sans Mono as default monospace font -->
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Noto Sans Mono</family>
    </prefer>
  </alias>
  
  <!-- Also set it for common monospace aliases -->
  <alias>
    <family>mono</family>
    <prefer>
      <family>Noto Sans Mono</family>
    </prefer>
  </alias>
  
  <alias>
    <family>courier</family>
    <prefer>
      <family>Noto Sans Mono</family>
    </prefer>
  </alias>
</fontconfig>
EOF

# Update GTK 2.0 configuration
echo "📝 Updating GTK 2.0 configuration..."
if [ -f ~/.gtkrc-2.0 ]; then
    # Add or update font line
    if grep -q "gtk-font-name" ~/.gtkrc-2.0; then
        sed -i 's/gtk-font-name=.*/gtk-font-name="Noto Sans Mono 11"/' ~/.gtkrc-2.0
    else
        echo 'gtk-font-name="Noto Sans Mono 11"' >> ~/.gtkrc-2.0
    fi
else
    echo 'gtk-font-name="Noto Sans Mono 11"' > ~/.gtkrc-2.0
fi

# Create/update GTK 3.0 configuration
echo "📝 Updating GTK 3.0 configuration..."
mkdir -p ~/.config/gtk-3.0
if [ -f ~/.config/gtk-3.0/settings.ini ]; then
    # Add or update font line
    if grep -q "gtk-font-name" ~/.config/gtk-3.0/settings.ini; then
        sed -i 's/gtk-font-name=.*/gtk-font-name=Noto Sans Mono 11/' ~/.config/gtk-3.0/settings.ini
    else
        echo 'gtk-font-name=Noto Sans Mono 11' >> ~/.config/gtk-3.0/settings.ini
    fi
else
    cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-font-name=Noto Sans Mono 11
EOF
fi

# Create/update GTK 4.0 configuration
echo "📝 Updating GTK 4.0 configuration..."
mkdir -p ~/.config/gtk-4.0
cat > ~/.config/gtk-4.0/settings.ini << 'EOF'
[Settings]
gtk-font-name=Noto Sans Mono 11
EOF

# Refresh font cache
echo "🔄 Refreshing font cache..."
fc-cache -fv > /dev/null 2>&1

# Verify configuration
echo "🔍 Verifying font configuration..."
MATCHED_FONT=$(fc-match monospace)
if echo "$MATCHED_FONT" | grep -q "NotoSansMono-Regular.ttf"; then
    echo "✅ Success! Noto Sans Mono is now the default monospace font"
    echo "   Matched: $MATCHED_FONT"
else
    echo "⚠️  Warning: Font may not have been set correctly"
    echo "   Matched: $MATCHED_FONT"
fi

echo ""
echo "📋 To see changes:"
echo "   • Restart applications (especially file managers like Thunar)"
echo "   • Log out and back in, or restart bspwm"
echo "   • New applications will automatically use Noto Sans Mono"
echo ""
echo "🎯 This affects:"
echo "   • Terminal emulators that respect fontconfig"
echo "   • File managers (Thunar, etc.)"  
echo "   • Text editors"
echo "   • Any application using monospace fonts"
echo ""
echo "✨ Font setup complete!"