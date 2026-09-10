# Linux Packaging

## ADDED Requirements

### Requirement: AppImage Packaging

The project SHALL provide an AppImage build path that packages the existing CMake Release artifact without requiring application source behavior changes.

#### Scenario: Fedora user runs AppImage

- GIVEN the AppImage package has been built from the existing CMake target
- WHEN a Fedora user marks the AppImage executable and runs it
- THEN A8Manager starts without unresolved dynamic library errors
- AND the packaged app uses the expected application icon and desktop metadata

### Requirement: Flatpak Packaging

The project SHALL provide a Flatpak manifest after AppImage packaging has validated the release artifact layout and metadata.

#### Scenario: Fedora user runs Flatpak

- GIVEN the Flatpak package has been built and installed locally
- WHEN a Fedora user launches A8Manager from the desktop or command line
- THEN A8Manager starts successfully
- AND file access, audio, and MIDI permissions needed by the application are documented

### Requirement: Non-Disruptive Packaging

Linux packaging SHALL remain separable from core application behavior and from Windows/macOS build behavior.

#### Scenario: Non-Linux developer builds from source

- GIVEN Linux packaging files are present
- WHEN a Windows or macOS developer configures the existing CMake project
- THEN packaging-specific tools are not required
- AND existing platform build behavior is unchanged
