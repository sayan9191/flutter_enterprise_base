# Contributing

## Getting Started

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Follow [PROJECT_SETUP.md](PROJECT_SETUP.md) for local setup
4. Read [CODING_GUIDELINES.md](CODING_GUIDELINES.md) and [ARCHITECTURE.md](ARCHITECTURE.md)

## Development Workflow

```
main (production-ready)
  └── develop (integration branch)
       └── feat/my-feature (your branch)
```

1. Branch from `develop`
2. Implement feature following Clean Architecture
3. Write tests (see [TESTING_GUIDE.md](TESTING_GUIDE.md))
4. Run `flutter analyze` and `flutter test`
5. Submit pull request to `develop`

## Pull Request Requirements

- [ ] Descriptive PR title following conventional commits
- [ ] Summary of changes and motivation
- [ ] Tests pass locally
- [ ] No analyzer errors
- [ ] Documentation updated if needed
- [ ] Screenshots for UI changes

## PR Template

```markdown
## Summary
- Brief description of changes

## Type
- [ ] Feature
- [ ] Bug fix
- [ ] Refactor
- [ ] Documentation

## Test Plan
- [ ] Unit tests added/updated
- [ ] Manual testing steps

## Screenshots (if UI)
```

## Adding a New Feature

Follow [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md):

1. Create feature folder structure
2. Implement domain → data → presentation
3. Register DI
4. Add routes
5. Write tests
6. Update documentation

## Code Style

- Run `dart format .` before committing
- Follow `very_good_analysis` lint rules
- Use meaningful commit messages

## Questions

Open an issue for architectural questions or create a discussion thread.

## Security

Report security vulnerabilities privately — do not open public issues for security bugs.
