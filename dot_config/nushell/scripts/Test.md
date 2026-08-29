# first

add:

```nu,no-run
module "command that need test" {
	use "command that need test"

	@test
	export def "test <a name>" [] {
		xxx
	}
}
export use "command that need test"
```

to user-fn_test.nu, and replace `<a name>` with the name of the command you want to test, and `xxx` with the test code.
