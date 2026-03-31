---
name: csngaq-cstree-test
description: Create and update C# tests in this repository with Tsinswreng.CsTreeTest conventions. Use when asked to add tests for a class/method, create or modify TestXxx testers, register cases via MkFnRegisterTest, wire testers into the nearest TestMgr/RegisterSubMgr chain, or apply database-test setup/cleanup patterns in Ngaq.Test projects.
---

# CsNgaq CsTreeTest

## Overview

Follow this workflow to implement tests in this repo with minimal drift from `Doc/Spec/Test.typ`.
Prefer existing local patterns over inventing new structure.

## Workflow

1. Locate the closest test project and folder for the target module.
2. Create or update `TestXxx` tester that implements `ITester`.
3. Register test cases in `RegisterTestsInto` using `MkFnRegisterTest` (or equivalent node register helper used nearby).
4. Register the tester in the nearest `TestMgr` via `RegisterTester<TestXxx>()`.
5. If that module-level `TestMgr` is not collected by parent manager, add `RegisterSubMgr(...)` in the parent.
6. Avoid touching test entrypoint (`Program.cs` / executor wiring) unless user explicitly asks.

## Naming Rules

- Name cases clearly so behavior is obvious.
- Keep names distinct within the same tester.
- Avoid vague names such as `Test1`, `Try`, `Temp`.

## Tester Structure Rules

- Prefer one tester class per main testee class.
- Prefer partial-class split: main assembly file (often `_TestXxx.cs`) plus per-method files.
- In each method-focused part, register only related cases.
- When registering testee method names, prefer `nameof(...)`.

## Manager Wiring Rules

- Higher-level `TestMgr` should usually collect child managers via `RegisterSubMgr(...)`, not register every tester directly.
- Reference implementation:
  - `Ngaq.Test/proj/Ngaq.Windows.Test/WindowsTestMgr.cs`
  - `Ngaq.Test/proj/Ngaq.Local.Test/LocalTestMgr.cs`

## Database Test Rules

- Insert required fixture data before DB-related tests run.
- Use unique fixture values to avoid collisions with existing records.
- Always hard-delete inserted fixture data after tests, regardless of success/failure.
- Do not repeat insert/cleanup in every single case if avoidable.
- You may run ordered cases so first case inserts and last case cleans up.

## Quick Acceptance Checklist

- Tester compiles and implements `ITester`.
- Cases are registered under `RegisterTestsInto` with clear names.
- Nearest `TestMgr` includes `RegisterTester<TestXxx>()`.
- Parent `TestMgr` includes `RegisterSubMgr(...)` when needed.
- For DB tests: fixture setup and guaranteed cleanup are both present.

## References

Read these when you need concrete patterns:

- `Doc/Spec/Test.typ`
- `Doc/Spec/TestSample.typ`
- `Ngaq.Test/proj/Ngaq.Windows.Test/WindowsTestMgr.cs`
- `Ngaq.Test/proj/Ngaq.Local.Test/LocalTestMgr.cs`
- `skills/csngaq-cstree-test/references/templates.md`

