# Add Minimal Fedora Build Support

## Summary

Document the minimum steps needed to build A8Manager from source on Fedora, and remove SSH-key friction from submodule initialization.

## Motivation

The project already builds on Fedora when dependencies and submodules are available. The current README says there is no Linux version yet, and `.gitmodules` uses SSH GitHub URLs that fail for contributors without configured SSH keys. A minimal update should make the existing CMake/JUCE build path reproducible without changing application code.

## Goals

- Make Fedora build steps clear and reproducible.
- Ensure submodules can be initialized without requiring a GitHub SSH key.
- Preserve existing Windows and macOS behavior.

## Non-Goals

- Do not rewrite the application architecture.
- Do not replace JUCE or CMake.
- Do not add CI in this change.
- Do not add AppImage or Flatpak packaging in this change.
- Do not add Linux desktop install metadata in this change.
- Do not make Fedora-specific source code changes.

## Proposed Change

1. Change JUCE and oolib submodule URLs from SSH to HTTPS.
2. Add Fedora dependency installation instructions to the README.
3. Add Fedora CMake build commands to the README.
4. Note the Fedora version used for verification.

## Risks

- Fedora package names may vary across Fedora releases.
- The README dependency list may include libraries currently discovered by JUCE even if disabled at application compile time.
- Runtime support still needs broader manual testing beyond the build and launch smoke test.
