## System monitor - Conky
## ref: http://www.linuxveda.com/2015/07/02/beautify-linux-mint-cinnamon-simple-tricks/3/
echo "Installing conky (system monitor widget)"
sudo apt-add-repository -y ppa:teejee2008/ppa
sudo apt-get update
sudo apt-get install conky-manager

## Docker - Plank
## Setting menu : Ctrl + Right mouse click
## ref: http://www.linuxveda.com/2015/07/02/beautify-linux-mint-cinnamon-simple-tricks/3/
echo "Installing plank (docker)"
sudo add-apt-repository ppa:ricotz/docky
sudo apt-get update
sudo apt-get install plank
