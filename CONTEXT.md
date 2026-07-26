# Personal Environment Configuration

Context for reconstructing and continuously maintaining a personal development environment used on macOS and NixOS-WSL from a single repository.

## Language

**Target Environment**:
An operating system, host, and user combination for which configuration is evaluated and applied.
_Avoid_: platform, machine

**Primary Environment**:
The target environment used day to day and treated as the baseline for configuration and verification.
_Avoid_: auxiliary target environment, default environment

**Auxiliary Target Environment**:
A target environment for using the shared user environment when working on an operating system other than the primary environment. It does not imply the same frequency of use or future maintenance level as the primary environment.
_Avoid_: primary environment, test environment

**Shared User Environment**:
Shell, CLI, editor, and agent configuration that preserves the same behavior across multiple target environments.
_Avoid_: shared host configuration, base system

**Host Configuration**:
The operating-system, service, and device settings specific to one target environment.
_Avoid_: shared configuration, user environment

**Configuration Source of Truth**:
The single editable version of configuration that is reflected in a runtime environment.
_Avoid_: copy, generated artifact

**Linked Dotfile**:
Configuration exposed where an application can read it while keeping the configuration source of truth intact.
_Avoid_: managed package, generated configuration

**Managed Application**:
An application whose presence and version are maintained automatically. It may be updated when the configuration is applied or by its own updater.
_Avoid_: manually managed application, configured application

**Manual Application**:
An application whose presence is recorded in the configuration but which is not installed, updated, or removed automatically.
_Avoid_: managed application, unmanaged application

**Agent Skill Source**:
An external or local collection of skills from which agent skills to use are selected.
_Avoid_: agent skill, agent configuration
