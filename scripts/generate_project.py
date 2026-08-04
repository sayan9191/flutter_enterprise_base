#!/usr/bin/env python3
"""Generates enterprise Flutter starter template source files."""

from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / "lib"


def write(rel: str, content: str) -> None:
    path = ROOT / rel
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content.strip() + "\n", encoding="utf-8")


def readme(folder: str, purpose: str) -> None:
    write(
        f"{folder}/README.md",
        f"# {folder.split('/')[-1].title()}\n\n{purpose}\n",
    )


# --- README files for folders ---
readmes = {
    "app": "Application bootstrap, lifecycle, and global BLoC observer.",
    "config": "Environment, theme, routing, and flavor configuration.",
    "config/env": "Environment variable loading and feature flags.",
    "config/theme": "Application theme configuration entry points.",
    "config/router": "GoRouter setup, guards, and route definitions.",
    "config/flavors": "Build flavor definitions for dev/qa/stage/prod.",
    "core": "Shared infrastructure used across all features.",
    "core/constants": "App-wide constant values and keys.",
    "core/network": "Dio client, interceptors, and API abstractions.",
    "core/storage": "Hive, SecureStorage, and SharedPreferences abstractions.",
    "core/logger": "Structured logging with release-mode suppression.",
    "core/exceptions": "Throwable exception hierarchy for error propagation.",
    "core/failure": "Domain-level failure types for use case results.",
    "core/errors": "Error mapping and global error handling.",
    "core/services": "Cross-cutting services (navigation, dialog, session).",
    "core/extensions": "Dart and Flutter extension methods.",
    "core/helpers": "Helper utilities for common operations.",
    "core/utils": "General-purpose utility classes.",
    "core/validators": "Input validation logic.",
    "core/permissions": "Permission request and status management.",
    "core/security": "Security hooks (biometric, jailbreak, SSL pinning).",
    "core/analytics": "Analytics abstraction with Firebase-ready hooks.",
    "core/base": "Base classes for BLoC, repository, use case, and data layers.",
    "core/widgets": "Reusable UI components shared across features.",
    "core/theme": "Design tokens: colors, typography, spacing, shadows.",
    "core/di": "GetIt service locator and dependency registration.",
    "core/resources": "Resource wrapper and Result type.",
    "shared": "Shared domain/data/presentation used by multiple features.",
    "features": "Feature modules following Clean Architecture.",
}
for folder, purpose in readmes.items():
    readme(folder, purpose)

print("README files created")
