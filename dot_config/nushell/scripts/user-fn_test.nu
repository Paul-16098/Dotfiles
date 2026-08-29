# nu-lint-ignore-file: add_doc_comment_exported_fn, missing_output_type
use std/assert
use std/testing *

module "ast get-last-command" {
  use ./user-fn.nu "ast get-last-command"

  @test
  export def "test 1" [] {
    assert equal "split chars" ("random chars|split chars" | ast get-last-command)
  }

  @test
  export def "test 2" [] {
    assert equal "split chars" ("%random chars|%split chars" | ast get-last-command)
  }

  @test
  export def "test 3" [] {
    assert equal "another command" ("random chars|split chars|^another command" | ast get-last-command)
  }
}

export use "ast get-last-command"
