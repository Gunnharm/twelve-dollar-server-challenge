set -euo pipefail

SQLITE=sqlite-amalgamation-3540100
SQLITE_SHA256=0a9c8e34352dad46006aa82836d5383bff9dc6bc9ce5a60553c05aa30e6ad1f9

cd "$(dirname "$0")"

echo "preparing"

if ! [[ -f "vendor/$SQLITE/sqlite3.c" ]]; then
    mkdir -p vendor
    cd vendor
    wget -q "https://sqlite.org/2026/$SQLITE.zip"
    if ! output=$(shasum -a 256 "$SQLITE.zip") || [[ ${output%% *} != "$SQLITE_SHA256" ]]; then
        echo "SQLite amalgamation archive does not match sha256 sum" >&2
        exit 1
    fi
    unzip $SQLITE.zip
    cd ..
fi


echo "building"
mkdir -p build
cc main.c -o build/main -g -I"vendor/$SQLITE"