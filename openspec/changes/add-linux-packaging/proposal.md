# Add Linux Packaging

## Summary

Create non-invasive Linux packaging for A8Manager, starting with AppImage and then adding Flatpak once the release layout and desktop metadata are proven.

## Motivation

A8Manager now has documented Fedora build steps and a Fedora CI source-build gate. The next product milestone for `buddha314/A8Manager` is a downloadable Linux build that users can run without manually installing the full development toolchain. Packaging should build on the existing CMake/JUCE output and avoid application behavior changes unless package testing exposes a concrete runtime issue.

## Goals

- Produce an AppImage recipe for Fedora-compatible Linux distribution.
- Add the minimum desktop metadata needed for a polished Linux app package.
- Evaluate and then add a Flatpak manifest after the AppImage path is working.
- Preserve the current CMake/JUCE target as the source of truth.
- Keep upstreamable source/build fixes separable from `buddha314` product packaging work.

## Non-Goals

- Do not replace the existing CMake build.
- Do not change Windows or macOS build behavior.
- Do not open a `cpr2323/A8Manager` upstream PR for packaging work unless explicitly requested.
- Do not add installer/update infrastructure beyond AppImage and Flatpak packaging.
- Do not make broad UI or application behavior changes as part of packaging.

## Proposed Change

1. Add desktop metadata shared by Linux packaging formats, including an application ID, `.desktop` file, and icon handling.
2. Add an AppImage build script or recipe that consumes the existing CMake Release artifact.
3. Smoke-test the AppImage on Fedora before adding additional packaging layers.
4. Add a Flatpak manifest after AppImage runtime behavior and metadata are verified.
5. Document packaging commands and artifact locations.
6. Keep any general CMake or Linux runtime fixes in small, extractable branches for possible later upstream PRs.

## Packaging Order

1. AppImage first, because it is the shortest path to a downloadable Linux artifact and should expose missing runtime libraries quickly.
2. Flatpak second, because it provides better desktop integration and sandboxing but requires more metadata, runtime, and portal decisions.

## Risks

- AppImage bundling may need careful filtering of host libraries and JUCE runtime dependencies.
- Flatpak sandboxing may expose file chooser, removable media, or audio/MIDI permission issues.
- Desktop metadata may require a stable application ID decision before release.
- Release builds may take longer than CI source-build checks because JUCE enables Release optimizations.
