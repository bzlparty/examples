# buildifier: disable=module-docstring
load("@aspect_rules_js//js:defs.bzl", "js_library", "js_run_devserver")
load("@npm//:typescript/package_json.bzl", "bin")
load("@rules_oci//oci:defs.bzl", "oci_image", "oci_tarball")
load("@rules_pkg//pkg:mappings.bzl", "pkg_files")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")
load("//tools:tsx.bzl", "tsx_test")

# buildifier: disable=function-docstring
def ts_library(name, srcs = [], deps = [], **kwargs):
    if len(srcs) == 0:
        srcs = native.glob(["*.ts"], exclude = ["*.spec.ts"])

    js_library(
        name = name,
        srcs = srcs,
        deps = ["//app:node_modules/frontlessjs"] + deps,
        **kwargs
    )

    tsx_test(
        name = "test",
        specs = native.glob(["*.spec.ts"]),
        tsconfig = "//app:tsconfig",
        data = [
            name,
            "//app:node_modules/@frontless-example/testing",
        ],
    )

    bin.tsc_test(
        name = "typecheck",
        args = [
            "--project",
            "$(location //app:tsconfig)",
        ],
        data = [
            name,
            "//app:tsconfig",
        ],
    )

    pkg_files(
        name = "files",
        srcs = [name],
        prefix = native.package_name(),
        visibility = kwargs.get("visibility"),
    )

def devserver(name, entry_point, data, tool):
    js_run_devserver(
        name = name,
        args = [
            "--enable-source-maps",
            entry_point,
        ],
        chdir = native.package_name(),
        data = [
            ":package.json",
            ":tsconfig.json",
        ] + data,
        tool = tool,
        visibility = ["//visibility:public"],
    )

# buildifier: disable=function-docstring
def bun_image(name, srcs, **kwargs):
    pkg_tar(
        name = "%s_layer" % name,
        srcs = srcs,
    )

    native.genrule(
        name = "%s_ports" % name,
        outs = ["%s.ports" % name],
        cmd = "echo 3000 > $(OUTS)",
    )

    oci_image(
        name = "%s_image" % name,
        base = "@distroless_bun",
        cmd = [
            "run",
            "main.ts",
        ],
        entrypoint = ["bun"],
        exposed_ports = ":%s_ports" % name,
        tars = [
            ":%s_layer" % name,
        ],
        **kwargs
    )

    repo_tag = "%s-%s:latest" % (
        native.module_name(),
        native.package_name(),
    )

    oci_tarball(
        name = "%s_tarball" % name,
        image = ":%s_image" % name,
        repo_tags = [repo_tag],
    )

    _docker_run_script(
        outs = "run_%s" % name,
        name = "%s_docker_run" % name,
        tarball = ":%s_tarball" % name,
        image = repo_tag,
        visibility = ["//tools:__subpackages__"],
    )

def _docker_run_script_impl(ctx):
    ctx.actions.write(
        output = ctx.outputs.outs,
        is_executable = True,
        content = """\
#!/usr/bin/env bash

bazel build {target}
bazel run {target}

docker run --rm --publish="{port}:3000" {image}
""".format(
            target = ctx.attr.tarball.label,
            image = ctx.attr.image,
            port = ctx.attr.port,
        ),
    )

_docker_run_script = rule(
    _docker_run_script_impl,
    attrs = {
        "outs": attr.output(),
        "image": attr.string(),
        "tarball": attr.label(allow_single_file = True),
        "port": attr.int(default = 3000),
    },
)
