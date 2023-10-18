if [[ $# -ne 1 ]]; then
    echo "Usage: You must provide exactly one argument!"
    exit 1
fi
cd $1
swift build -c release
cd .build/release
cp -f $1 /usr/local/bin/$1
