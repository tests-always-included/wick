#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-wait-for"
}

@test "waiting for true" {
    wick-wait-for 3 true
}

@test "waiting for false" {
    ! wick-wait-for 3 false
}

@test "wait for file creation" {
    rm -f /tmp/moocow

    (
         sleep 2
         touch /tmp/moocow
    ) &

    wick-wait-for 4 [ -f /tmp/moocow ] && rm -f /tmp/moocow
}
