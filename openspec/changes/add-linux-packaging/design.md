## Context

A8Manager is a JUCE/CMake desktop GUI application. Fedora source builds are verified, and the repository now has a Fedora 44 Debug CI build gate. Linux packaging should consume the existing CMake output instead of introducing a second build system.

Current packaging inventory:

- Release executable: `/tmp/a8manager-review-build/A8Manager_artefacts/Release/A8Manager`
- Binary type: x86-64 ELF, dynamically linked, interpreter `/lib64/ld-linux-x86-64.so.2`
- Approximate Release binary size: 12M
- Launch smoke: local Fedora launch ran until killed by `timeout 10`, with no immediate loader errors
- Icon candidate: `Source/GUI/Assimil8or/Data/377906243_984640136172516_2914152204379747274_n.png`
- Icon properties: 514x514 PNG, 8-bit RGBA
- Existing Linux desktop metadata: none found

Observed runtime library dependencies from `ldd`:

- `libfontconfig.so.1`
- `libfreetype.so.6`
- `libasound.so.2`
- `libstdc++.so.6`
- `libm.so.6`
- `libgcc_s.so.1`
- `libc.so.6`
- `libxml2.so.2`
- `libz.so.1`
- `libbz2.so.1`
- `libpng16.so.16`
- `libharfbuzz.so.0`
- `libbrotlidec.so.1`
- `liblzma.so.5`
- `libglib-2.0.so.0`
- `libgraphite2.so.3`
- `libbrotlicommon.so.1`
- `libpcre2-8.so.0`

Packaging-sensitive runtime areas found in source:

- File chooser usage for folder selection, import/export, ZIP import/export, missing-file lookup, and shared oolib file labels
- Audio playback through JUCE audio utilities and ALSA-linked runtime libraries
- MIDI setup editing in the application UI, with Flatpak portal/permission implications still to validate
- Persistent properties under JUCE `userApplicationDataDirectory`

## Goals / Non-Goals

**Goals:**

- Use `io.github.buddha314.A8Manager` as the Linux application ID for fork-owned packaging.
- Keep the existing CMake target as the only application build input.
- Share desktop metadata between AppImage and Flatpak packaging where practical.
- Add AppImage first, then Flatpak after the AppImage artifact layout is proven.

**Non-Goals:**

- Do not change application behavior during packaging metadata work.
- Do not open packaging PRs against `cpr2323/A8Manager` without explicit user approval.
- Do not require packaging tools for normal CMake source builds.

## Decisions

- Use `io.github.buddha314.A8Manager` as the Linux app ID.
  - Rationale: the product fork is hosted under `github.com/buddha314/A8Manager`, and the `io.github` reverse-DNS pattern is widely used for GitHub-hosted Linux desktop apps.
  - Alternative considered: `com.buddha314.A8Manager`; rejected because there is no confirmed owned product domain in this repository.

- Keep packaging files under `packaging/linux`.
  - Rationale: this keeps Linux packaging assets separate from core source, CMake, and platform-neutral docs.
  - Alternative considered: top-level packaging files; deferred until a specific tool requires a root-level manifest.

- Reuse the existing PNG as the initial package icon source.
  - Rationale: it is already the app icon in CMake and avoids introducing new artwork during packaging enablement.
  - Alternative considered: generating a new icon set now; deferred until package smoke tests prove the artifact shape.

## Risks / Trade-offs

- AppImage library bundling may miss indirect JUCE runtime dependencies -> validate with `ldd` and Fedora launch smoke.
- Flatpak sandboxing may restrict file, audio, or MIDI access -> document required finish-args and test real workflows before release.
- The existing 514x514 PNG is an unusual icon size -> package scripts may need to resize/copy it into standard icon directories.
- CI Debug builds prove compile/link compatibility but not Release packaging performance -> packaging tasks should run Release builds explicitly.
