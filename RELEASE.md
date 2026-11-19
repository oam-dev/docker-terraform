# Releasing docker-terraform

This image is the runner terraform-controller starts its Jobs in (its chart's `terraformImage`), so each release line
stays on one Terraform version: users can upgrade the image without migrating their Terraform state.

## Branches

| Branch | What it is | Tags |
| --- | --- | --- |
| `master` | development; the next minor release | none; every push publishes `latest` |
| `release-1.3` | OpenTofu 1.13.9, `linux/amd64` + `linux/arm64` | `1.3.x` (`1.3.0-alpha.1` today) |
| `release-1.2` | Terraform 1.5.5, `linux/amd64` | `1.2.x` |
| `release-1.1` | Terraform 1.1.9, `linux/amd64` | `1.1.x` |

The release branches get security fixes (base image, tools, bundled providers); new features go to `master`. How long
`release-1.1` and `release-1.2` stay maintained after `1.3.0` is not decided yet.

A new minor line starts with a `release-x.y` branch cut from `master` at the commit of its first tag (as `release-1.3`
at `v1.3.0-alpha.1`).

## Backports

A fix goes to `master` first, then to the release branches that need it. The
[Backport workflow](.github/workflows/backport.yml) opens the backport pull requests:

- **Before merging**, add a label per branch: `backport release-1.1`, `backport release-1.2`, `backport release-1.3`.
  When the pull request is merged, the workflow cherry-picks its commits (with `-x`) onto each branch and opens one pull
  request per branch.
- **After merging**, a maintainer comments `/backport release-1.2` (or `/backport 1.2`; several branches separated by
  spaces) on the merged pull request. Adding a label after the merge does nothing.

If a commit doesn't apply, the workflow says so in a comment and the run fails; backport that branch by hand
(`git cherry-pick -x`) in a pull request titled `[Backport release-x.y] <title>`.

## What the Docker workflow publishes

[docker.yml](.github/workflows/docker.yml) publishes to `docker.io/oamdev/docker-terraform`:

| Trigger | Image tag |
| --- | --- |
| a push to `master` | `latest` |
| a `vX.Y.Z` tag (on a release branch) | `X.Y.Z` |
| a manual run on `release-x.y` | `release-x.y-<short sha>`: a release candidate, not for users |
| a pull request to `master` or `release-*` | built, not pushed |

On `master` and `release-1.3`, every run first builds each platform and runs its tools (`terraform version` must
report OpenTofu on that platform); nothing is pushed if that fails. A tag publishes to users at once, and it doesn't
move `latest`.

## Making a release

1. Merge the fixes into the release branch (backports above).
2. Build a candidate: Actions → Docker → Run workflow → the release branch. It publishes
   `oamdev/docker-terraform:release-x.y-<short sha>`.
3. Test the candidate: scan it, and run it under terraform-controller (an upgrade from the previous tag with existing
   Configurations, so their state is kept).
4. Tag the tested commit, `vX.Y.Z` on `release-x.y`. Tags are never moved or reused: a fix after tagging is the next
   patch.
5. Check the published image (it is rebuilt from the tag, so its digest differs from the candidate's), then publish the
   GitHub Release with the release notes: what changed, the tools and providers, the image digest, and how to upgrade.
   Only the newest final release is marked Latest; an `-alpha` / `-beta` / `-rc` tag is a pre-release.
6. Update the tag table in the [README](README.md), and terraform-controller's default `terraformImage` if the line is
   its default runner.
