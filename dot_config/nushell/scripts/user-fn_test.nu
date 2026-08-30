# nu-lint-ignore-file: add_doc_comment_exported_fn, missing_output_type
use std/assert
use std/testing *

module "ast get-last-command" {
  use ./user-fn.nu "ast get-last-command"

  # test for command without sigil
  @test
  export def "test 1" [] {
    assert equal "split chars" ("random chars|split chars" | ast get-last-command)
  }

  # test for command with sigil
  @test
  export def "test 2" [] {
    assert equal "split chars" ("%random chars|%split chars" | ast get-last-command)
  }

  # test for command with sigil
  @test
  export def "test 3" [] {
    assert equal "another command" ("random chars|split chars|^another command" | ast get-last-command)
  }

  # test for command with flag
  @test
  export def "test 4" [] {
    assert equal "another command --flag" ("random chars|split chars|^another command --flag" | ast get-last-command)
  }
}
export use "ast get-last-command"

module "ast remove-flag" {
  use ./user-fn.nu "ast remove-flag"

  # test for command without sigil
  @test
  export def "test 1" [] {
    assert equal "another" ("^another command --flag" | ast remove-flag)
  }

  # test for command with sigil
  @test
  export def "test 2" [] {
    assert equal "split chars" ("%split chars --code-points" | ast remove-flag)
  }
}
export use "ast remove-flag"
