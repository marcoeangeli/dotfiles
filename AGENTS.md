# Global agent preferences

- Do not add superfluous comments. Add comments only when the code or intent is not obvious.
- Keep implementations as simple as possible. Do not overengineer.
- Match function contracts to actual callers: require inputs they always supply, apply defaults once at input boundaries, and avoid branches for unreachable states.
- Update test fixtures to match production contracts instead of adding runtime flexibility solely for tests.
- When changing enum values or aliases, audit dependent mappings, comparisons, and serialization; add regression tests for affected behavior.
