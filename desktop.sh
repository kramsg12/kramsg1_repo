
$user = Sys.info()[["user"]]
wget https://github.com/kramsg12/kramsg1_repo/raw/master/desktop/cinnamon.tar.xz
tar -xf cinnamon.tar.xz
cp -rf ./cinnamon/skel/* $HOME
