#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickPortUp"
}

@test "lib/wickPortUp: linux - exists" {
    mock-command netstat wickPortUp/linux
    wickPortUp tcp 22
}

@test "lib/wickPortUp: linux - fail" {
    mock-command netstat wickPortUp/linux
    ! wickPortUp udp 22
}
