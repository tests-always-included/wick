#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-port-up"
}

@test "lib/wick-port-up: linux - exists" {
    mock-command netstat wick-port-up/linux
    wickPortUp tcp 22
}

@test "lib/wick-port-up: linux - fail" {
    mock-command netstat wick-port-up/linux
    ! wickPortUp udp 22
}
