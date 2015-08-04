#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-wait-for"
}

@test "lib/wick-wait-for: waiting for true" {
    wick-wait-for 3 true
}

@test "lib/wick-wait-for: waiting for false" {
    ! wick-wait-for 3 false
}

@test "lib/wick-wait-for: wait for file creation" {
    rm -f /tmp/moocow

    (
         sleep 2
         touch /tmp/moocow
    ) &

    wick-wait-for 4 [ -f /tmp/moocow ] && rm -f /tmp/moocow
}
