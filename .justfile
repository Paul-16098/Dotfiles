set shell := ["nu", "-c"]

# use nu-check to check all .nu files in the project
test *file:
    [{{ file }}] | default --empty (glob **/*.nu --no-dir) | tee { print $in } | path expand | nu-check --debug | if not $in { exit 1 }

lint:
    nu-lint

# warn: this is unstable
fmt:
    nufmt

# update numd documentation
update-numd-doc:
    nu .vscode/update-numd-doc.nu
