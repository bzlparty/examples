# frontless-example

Website: https://www.frontless.dev/
Github: [frontlessdev/frontless-js](https://github.com/frontlessdev/frontless-js)

Install dependencies for all workspaces:

```bash
pnpm install
```

Serve files from `/app`:

```bash
bazel run //app
```

Run app oci image with `docker`:

```bash
./tools/docker/run_app
```

Run all test:

```bash
bazel test //...
```
