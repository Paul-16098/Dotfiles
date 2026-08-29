set shell := ["nu", "-c"]

# use nu-check to check all .nu files in the project
test *file:
    use ../nupm/modules/nutest\;nutest run-tests
lint:
    nu-lint
# warn: this is unstable
fmt:
    nufmt .
# update numd documentation
update-numd-doc:
    nu .vscode/update-numd-doc.nu
push:
    chezmoi apply
    chezmoi merge-all
    git push
