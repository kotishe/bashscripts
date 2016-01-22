#!/bin/sh
# Xavier de Pedro Puente - UEB-VHIR
# http://ueb.vhir.org

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
new_username=""
verbose=0

while getopts "h?vn:" opt; do
    case "$opt" in
    h|\?)
        echo "Tip: Run this script with the username as argument. I.e., for user foo.bar, run the script as 'sudo sh addb52user.sh foo.bar'"
        exit 0
        ;;
    v)  verbose=1
        echo "Tip: You can also specify the new user with the argument '-n foo.bar' (i.e. 'sudo sh addb52user.sh -n foo.bar')"
	echo "verbose=$verbose, new_user='$new_username', Leftovers: $@"
        ;;
    n)  new_username=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

newuser="$@"
adduser $newuser --force-badname
echo "* System user created..."
echo "export LIBGL_ALWAYS_INDIRECT=yes" >> /home/$newuser/.bashrc
echo "export PATH=$PATH:/usr/local/stata" >> /home/$newuser/.bashrc
echo "* His/her .bashrc tweaked..."
cd /home/ueb/scripts/templates4systemusers;cp --parents Desktop/*.desktop /home/$newuser/;cd ~
echo "* Desktop shortcuts added..."
cd /home/ueb;cp --parents .java/deployment/cache/6.0/35/442040a3-1e81535d.ico /home/$newuser/;cd ~
echo "* Desktop icons for the previous shortcuts provided..."
cd /home/ueb/scripts/templates4systemusers;cp --parents .config/lxsession/LXDE/autostart /home/$newuser/;cd ~
echo "* Keyboard fixed..."
cd /home/ueb/scripts/templates4systemusers;cp --parents .config/pcmanfm/LXDE/*.conf /home/$newuser/;cd ~
echo "* Desktop background changed..."
sed -i -e "s/foo.bar/$newuser/g" /home/$newuser/Desktop/*.desktop
echo "* Fixed paths for "$newuser!" in desktop icons..."
cd /home/$newuser/;chown $newuser:$newuser Desktop Desktop/* -R;cd ~
cd /home/$newuser/;chown $newuser:$newuser .config .config/* -R;cd ~
echo "* Ownership and permissions of new folders and files fixed..."
echo "...We are done! :-)"
# End of file