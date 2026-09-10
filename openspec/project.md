# A8Manager OpenSpec Notes

## Purpose

A8Manager is a JUCE/CMake desktop application for managing Rossum Electro-Music Assimil8or presets and sample files.

## Compatibility Principle

Linux and Fedora enablement should be packaging and validation work first. Avoid application behavior changes unless a Fedora runtime test exposes a concrete issue.

## Contribution Workflow

Push branches and collaboration work to `buddha314/A8Manager`. Do not open pull requests against `cpr2323/A8Manager` until the work is further along and the user explicitly asks for an upstream PR.

## Platform Scope

- Keep Windows and macOS build behavior unchanged.
- Keep the existing CMake/JUCE target structure as the source of truth.
- Prefer documentation, CI, and packaging files over platform-specific code paths.
- Track Linux packaging separately from core application changes.

## Fedora Verification Baseline

The current CMake build was verified on Fedora 44 KDE with:

```bash
cmake -S . -B /tmp/a8manager-review-build -DCMAKE_BUILD_TYPE=Release
cmake --build /tmp/a8manager-review-build --config Release
timeout 10 /tmp/a8manager-review-build/A8Manager_artefacts/Release/A8Manager
```

The build completed and produced a Linux x86-64 ELF executable.
