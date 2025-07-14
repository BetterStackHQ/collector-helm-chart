# Release Process

To release a new version of the chart:

1. Update the version in `Chart.yaml`
2. Commit your changes
3. Tag the release: `git tag v0.1.0`
4. Push the tag: `git push origin v0.1.0`

The GitHub Actions workflow will automatically:
- Package the chart
- Create a GitHub release
- Update the Helm repository index on GitHub Pages
