#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change the current working directory to the script's directory
cd "$SCRIPT_DIR" || { echo "Failed to change directory to script's location. Exiting."; exit 1; }

read -p "Install Bluecurve? (y/N): " user_input

# Default to 'N' if the input is empty
user_input=${user_input:-N}

if ! [[ "$user_input" =~ ^[Yy]$ ]]; then
	echo "Exiting."
	exit 1
fi

function compile_engine {
	cd engine/src
	rm -rf build # Remove build directory if it already exists
	mkdir build && cd build
	cmake ..
	make && make install
	cd "$SCRIPT_DIR"
}

ARCH=$(uname -m)

# Copy the GTK 2 engine to the appropriate directory
if [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "i686" ] || [ "$ARCH" = "i386" ]; then
	read -p "Install pre-compiled GTK 2 engine? Selecting no will compile the engine instead (Y/n): " user_input

	# Default to 'Y' if the input is empty
	user_input=${user_input:-Y}

	if [[ "$user_input" =~ ^[Yy]$ ]]; then
		echo "Installing GTK 2 engine..."
    	mkdir -p ~/.gtk-2.0/engines
		
		if [ "$ARCH" = "x86_64" ]; then
			cp engine/x86_64/libbluecurve.so ~/.gtk-2.0/engines
		else
			cp engine/i686/libbluecurve.so ~/.gtk-2.0/engines
		fi
	else
		echo "Compiling GTK 2 engine..."
		compile_engine		
	fi

else
	# If user is running something other than x86_64 or i686, they have to manually compile the theme
	echo "Compiling GTK 2 engine..."
	compile_engine
fi

# Copy icon set
echo "Installing icon set..."
mkdir -p ~/.icons
cp -r icons/* ~/.icons

# Copy themes
echo "Installing themes..."
mkdir -p ~/.themes
rm -rf ~/.themes/Bluecurve # Delete old theme files
rm -rf ~/.themes/Bluecurve-BerriesAndCream
rm -rf ~/.themes/Bluecurve-Classic-RH8
rm -rf ~/.themes/Bluecurve-Classic-RH9
rm -rf ~/.themes/Bluecurve-Gnome
rm -rf ~/.themes/Bluecurve-Grape
rm -rf ~/.themes/Bluecurve-Lime
rm -rf ~/.themes/Bluecurve-Slate
rm -rf ~/.themes/Bluecurve-Strawberry
rm -rf ~/.themes/Bluecurve-Tangerine
cp -r themes/* ~/.themes

read -p "Install the Luxi font family? (only do this if your distribution does not include them) (y/N): " user_input

# Default to 'N' if the input is empty
user_input=${user_input:-N}

if [[ "$user_input" =~ ^[Yy]$ ]]; then
	echo "Installing the Luxi font family..."
	mkdir -p ~/.local/share/fonts
	cp fonts/*.ttf ~/.local/share/fonts
fi

echo " "
echo "Bluecurve has been installed on your system!"

