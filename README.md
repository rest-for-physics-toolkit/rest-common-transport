# rest-common-transport

Electron transport tables (drift velocity, diffusion, Townsend and attachment versus the field) shared by the
projects of rest-for-physics-toolkit for [restv2](https://github.com/rest-for-physics-toolkit/rest-framework),
computed with `restGarfield` (Magboltz): gases for now, also other media.

The medium files are committed with their configurations (they are small, and too slow to compute in a CI)
and are the assets of each release (a tag `v*`), so a project reads a fixed version of them by URL, in
`mediumFile` of `TRestDetectorMedium`:

```yaml
medium:
  class: "TRestDetectorMedium"
  name: "Ar99_iC4H10_1"
  mediumFile: "https://github.com/rest-for-physics-toolkit/rest-common-transport/releases/download/v1.0/ArIso.root"
```

restv2 downloads a URL once and keeps it in `$REST_HOME/.rest/download` (it works offline afterwards, e.g. in
the nodes of a cluster).

Part of the shared resources of restv2 (topic `rest-common`):
[rest-common-materials](https://github.com/rest-for-physics-toolkit/rest-common-materials) (Geant4 materials),
transport (this repository) and
[rest-common-readouts](https://github.com/rest-for-physics-toolkit/rest-common-readouts) (detector readouts).

## Catalogue

Computed at 1 bar and 293.15 K, from 10 to 3000 V/cm with 50 logarithmic nodes; the medium scales them with
E/p to its pressure. A file holds several media (the concentrations of a mixture), named by their
composition in %:

| Asset | Media | Configuration |
|---|---|---|
| `ArIso.root` | `Ar99_iC4H10_1`, `Ar98_iC4H10_2`, `Ar95_iC4H10_5`, `Ar90_iC4H10_10` | `ArIso.yaml` |
| `NeIso.root` | `Ne99_iC4H10_1`, `Ne98_iC4H10_2`, `Ne95_iC4H10_5`, `Ne90_iC4H10_10` | `NeIso.yaml` |
| `NeXeIso.root` | `Ne49_Xe49_iC4H10_2` | `NeXeIso.yaml` |

## Generation

With restv2 built with `restGarfield` in the environment (its `thisREST.sh` sourced), `./generate.sh`
computes all the media at once (each one splitting its field nodes in processes, `restGarfield --jobs`); it
takes minutes on a machine with ~256 cores, too slow for a CI.

A new medium: a `restGarfield` YAML, its line in `generate.sh` and its medium file, committed together (the
CI, `.github/workflows/release.yml`, checks that the `mediumFile` of each YAML is in the repository).

## Release

1. Check the CI of `master`.
2. `git tag v1.1 && git push origin v1.1`: the CI creates the release with the medium files.
