#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
APP_NAME="A8Manager"
APP_ID="io.github.buddha314.A8Manager"
BUILD_CONFIG="${A8MANAGER_BUILD_CONFIG:-Release}"
BUILD_DIR="${A8MANAGER_BUILD_DIR:-$ROOT_DIR/cmake_build}"
APPDIR="${A8MANAGER_APPDIR:-$ROOT_DIR/build/appimage/$APP_NAME.AppDir}"
OUT_DIR="${A8MANAGER_APPIMAGE_OUT_DIR:-$ROOT_DIR/build/appimage}"
BINARY="$BUILD_DIR/A8Manager_artefacts/$BUILD_CONFIG/$APP_NAME"
DESKTOP_FILE="$ROOT_DIR/packaging/linux/$APP_ID.desktop"
ICON_SOURCE="$ROOT_DIR/Source/GUI/Assimil8or/Data/377906243_984640136172516_2914152204379747274_n.png"

usage() {
    printf 'Usage: %s [--appdir-only]\n' "$(basename "$0")"
    printf '\n'
    printf 'Environment:\n'
    printf '  A8MANAGER_BUILD_DIR          CMake build directory, default: %s\n' "$BUILD_DIR"
    printf '  A8MANAGER_BUILD_CONFIG       CMake build config, default: %s\n' "$BUILD_CONFIG"
    printf '  A8MANAGER_APPDIR             AppDir output path, default: %s\n' "$APPDIR"
    printf '  A8MANAGER_APPIMAGE_OUT_DIR   AppImage output directory, default: %s\n' "$OUT_DIR"
    printf '  APPIMAGETOOL                 Path to appimagetool, default: appimagetool from PATH\n'
    printf '  APPIMAGE_RUNTIME             Optional path to type2 runtime file\n'
}

APPDIR_ONLY=0
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
    exit 0
elif [[ "${1:-}" == "--appdir-only" ]]; then
    APPDIR_ONLY=1
elif [[ $# -gt 0 ]]; then
    usage >&2
    exit 2
fi

if [[ ! -x "$BINARY" ]]; then
    printf 'error: expected executable not found: %s\n' "$BINARY" >&2
    printf "hint: run \`cmake -B cmake_build -DCMAKE_BUILD_TYPE=Release\` and \`cmake --build cmake_build --config Release\` first.\n" >&2
    exit 1
fi

if [[ ! -f "$DESKTOP_FILE" ]]; then
    printf 'error: desktop file not found: %s\n' "$DESKTOP_FILE" >&2
    exit 1
fi

if [[ ! -f "$ICON_SOURCE" ]]; then
    printf 'error: icon source not found: %s\n' "$ICON_SOURCE" >&2
    exit 1
fi

if command -v desktop-file-validate >/dev/null 2>&1; then
    desktop-file-validate "$DESKTOP_FILE"
fi

rm -rf "$APPDIR"
mkdir -p "$OUT_DIR"

install -Dm755 "$BINARY" "$APPDIR/usr/bin/$APP_NAME"
install -Dm644 "$DESKTOP_FILE" "$APPDIR/$APP_ID.desktop"
install -Dm644 "$DESKTOP_FILE" "$APPDIR/usr/share/applications/$APP_ID.desktop"

resize_icon() {
    local size="$1"
    local output="$APPDIR/usr/share/icons/hicolor/${size}x${size}/apps/$APP_ID.png"

    mkdir -p "$(dirname "$output")"

    if command -v magick >/dev/null 2>&1; then
        magick "$ICON_SOURCE" -resize "${size}x${size}" "$output"
    elif command -v convert >/dev/null 2>&1; then
        convert "$ICON_SOURCE" -resize "${size}x${size}" "$output"
    elif [[ "$size" == "512" ]]; then
        install -Dm644 "$ICON_SOURCE" "$output"
    else
        printf 'warning: ImageMagick not found; skipping %sx%s icon\n' "$size" "$size" >&2
    fi
}

for size in 16 32 48 64 128 256 512; do
    resize_icon "$size"
done

install -Dm644 "$APPDIR/usr/share/icons/hicolor/512x512/apps/$APP_ID.png" "$APPDIR/$APP_ID.png"
ln -s "$APP_ID.png" "$APPDIR/.DirIcon"

cat > "$APPDIR/AppRun" <<'APPRUN'
#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
exec "$HERE/usr/bin/A8Manager" "$@"
APPRUN
chmod +x "$APPDIR/AppRun"

printf 'Created AppDir: %s\n' "$APPDIR"

if [[ "$APPDIR_ONLY" -eq 1 ]]; then
    exit 0
fi

APPIMAGETOOL_BIN="${APPIMAGETOOL:-}"
if [[ -z "$APPIMAGETOOL_BIN" ]] && command -v appimagetool >/dev/null 2>&1; then
    APPIMAGETOOL_BIN="$(command -v appimagetool)"
fi

if [[ -z "$APPIMAGETOOL_BIN" || ! -x "$APPIMAGETOOL_BIN" ]]; then
    printf 'error: appimagetool not found. Install it or set APPIMAGETOOL=/path/to/appimagetool.\n' >&2
    printf "hint: use \`%s --appdir-only\` to create only the AppDir.\n" "$0" >&2
    exit 1
fi

APPIMAGETOOL_ARGS=()
if [[ -n "${APPIMAGE_RUNTIME:-}" ]]; then
    if [[ ! -f "$APPIMAGE_RUNTIME" ]]; then
        printf 'error: APPIMAGE_RUNTIME does not exist: %s\n' "$APPIMAGE_RUNTIME" >&2
        exit 1
    fi

    APPIMAGETOOL_ARGS+=(--runtime-file "$APPIMAGE_RUNTIME")
fi

ARCH="${ARCH:-x86_64}" "$APPIMAGETOOL_BIN" "${APPIMAGETOOL_ARGS[@]}" "$APPDIR" "$OUT_DIR/$APP_NAME-$BUILD_CONFIG-x86_64.AppImage"
