#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-hash"
    . "$WICK_DIR/lib/wick-indirect"
}

@test "lib/wick-hash: hashing a file" {
    mock-command md5sum wick-hash/generic
    wickHash result test-file
    [[ "$result" == "d41d8cd98f00b204e9800998ecf8427e" ]]
}
