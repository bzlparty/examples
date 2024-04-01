"Internal Rules"

def readme(name, out = "README.md", **kwargs):
    _readme(
        name = name,
        out = out,
        **kwargs
    )

def _readme_impl(ctx):
    linklist = ctx.actions.declare_file("%s_links.md" % ctx.label.name)
    ctx.actions.run_shell(
        outputs = [linklist],
        inputs = [ctx.file.dirlist],
        command = """\
cat {dirlist}  | xargs -I "%" echo "- [%](./%/)" > {output}
""".format(dirlist = ctx.file.dirlist.path, output = linklist.path),
    )
    ctx.actions.run_shell(
        outputs = [ctx.outputs.out],
        inputs = [ctx.file.src, linklist],
        command = """\
source=$(<{source})
linklist=$(<{linklist})
echo "${{source//<!-- LINKLIST -->/$linklist}}" > {output}
""".format(source = ctx.file.src.path, linklist = linklist.path, output = ctx.outputs.out.path),
    )
    return [DefaultInfo(files = depset([ctx.outputs.out]))]

_readme = rule(
    _readme_impl,
    attrs = {
        "src": attr.label(allow_single_file = True, mandatory = True),
        "dirlist": attr.label(allow_single_file = True, mandatory = True),
        "out": attr.output(mandatory = True),
    },
)

DIRLIST_SCRIPT = """\
#!/usr/bin/env bash
resolved_path=$(readlink -f -- "$1")
workdir_path=$(dirname "$resolved_path")
dirs=$(find "$workdir_path" -maxdepth 1 -mindepth 1 -type d -not -name '.*' | xargs -n 1 basename | sort)
echo "$dirs" | grep -Evw '{exclude}' > "$2"
"""

def _dirlist_impl(ctx):
    src = ctx.file._src
    out = ctx.actions.declare_file("%s.out" % ctx.attr.name)
    script = ctx.actions.declare_file("%s.sh" % ctx.attr.name)

    ctx.actions.write(
        output = script,
        content = DIRLIST_SCRIPT.format(exclude = "|".join(ctx.attr.exclude)),
        is_executable = True,
    )

    args = ctx.actions.args()
    args.add(src.path)
    args.add(out.path)

    ctx.actions.run(
        inputs = [src, script],
        outputs = [out],
        executable = script,
        arguments = [args],
        execution_requirements = {
            "no-sandbox": "1",
            "no-remote": "1",
            "local": "1",
        },
    )
    return [DefaultInfo(files = depset([out]))]

dirlist = rule(
    _dirlist_impl,
    attrs = {
        "_src": attr.label(allow_single_file = True, default = "//:README.md"),
        "exclude": attr.string_list(default = []),
    },
    doc = "Writes the full path of the current workspace dir to a file.",
)
