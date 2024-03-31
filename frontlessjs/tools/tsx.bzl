# buildifier: disable=module-docstring
load("@npm//tools:tsx/package_json.bzl", "bin")

def tsx_test(name, tsconfig, specs = [], data = [], **kwargs):
    bin.tsx_test(
        name = name,
        args = [
            "--tsconfig",
            "$(location %s)" % tsconfig,
            "--test",
        ] + ["$(location %s)" % s for s in specs],
        data = data + specs + [tsconfig],
        **kwargs
    )
