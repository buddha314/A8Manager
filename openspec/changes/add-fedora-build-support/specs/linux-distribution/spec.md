# Fedora Build Support

## ADDED Requirements

### Requirement: Fedora Build Documentation

The project SHALL document Fedora build dependencies and CMake build commands.

#### Scenario: New Fedora contributor builds from source

- GIVEN a Fedora workstation with development tools available
- WHEN the contributor follows the Linux build instructions
- THEN submodules initialize successfully
- AND CMake configures the project
- AND the A8Manager executable is produced

### Requirement: HTTPS Submodule Initialization

The project SHALL use public HTTPS submodule URLs so contributors can initialize submodules without GitHub SSH credentials.

#### Scenario: Contributor initializes submodules

- GIVEN a contributor has cloned the repository over HTTPS
- WHEN the contributor runs `git submodule update --init --recursive`
- THEN JUCE and oolib are fetched without requiring an SSH key

### Requirement: Non-Disruptive Platform Support

Linux support SHALL be added without changing Windows or macOS build behavior unless required by a proven cross-platform issue.

#### Scenario: Existing platform builds

- GIVEN the Linux support files are present
- WHEN a Windows or macOS build is configured
- THEN existing CMake/JUCE app configuration remains the source of truth
- AND no Fedora-specific packaging tools are required for those builds
