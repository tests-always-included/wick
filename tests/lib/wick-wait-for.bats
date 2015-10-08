#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickWaitFor"
}

@test "lib/wickWaitFor: waiting for true" {
    wickWaitFor 3 true
}

@test "lib/wickWaitFor: waiting for false" {
    ! wickWaitFor 3 false
}

@test "lib/wickWaitFor: wait for file creation" {
    rm -f /tmp/moocow

    (
         sleep 2
         touch /tmp/moocow
    ) &

    wickWaitFor 4 [ -f /tmp/moocow ] && rm -f /tmp/moocow
}
