# Podman

## login

Running `podman login` to a container registry with 2FA will fail with the user
password. Therefore, a personal access token (PAT) needs to be created.

The `auth.json` file:

``` json
{
  "auths": {},
  "credHelpers": {
    "registry.gitlab.com": "gopass"
  }
}
```
