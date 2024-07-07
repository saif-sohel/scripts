mkdir -p "$HOME/android"
cd "$HOME/android"
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
sudo apt install unzip -y
unzip platform-tools-latest-linux.zip
echo "# add Android SDK platform tools to path" >> "$HOME/.profile"
echo "if [ -d "$HOME/android/platform-tools" ]; then" >> "$HOME/.profile"
echo '    PATH="$HOME/android/platform-tools:$PATH"' >> "$HOME/.profile"
echo "fi" >> "$HOME/.profile"
rm platform-tools-latest-linux.zip
