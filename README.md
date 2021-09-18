# aws-terraform-tools action

This action installs the tools [tfenv](https://github.com/tfutils/tfenv) and [tgenv](https://github.com/taosmountain/tgenv), adds them to github actions path and uses them to install the latest terrafrom and terragrunt version.

## Inputs

### `tfenv-version`

**Optional** Version of tfenv that should be installed.

### `tgenv-version`

**Optional** Version of tgenv that should be installed.

## Example usage
```
uses: seligerit/aws-terraform-tools@v1
```

or with specific tfenv version:

```
uses: seligerit/aws-terraform-tools@v1
with:
  tfenv-version: '2.2.2'
```
