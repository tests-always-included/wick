#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickIndirectArray"
}

test-one-level() {
    local RESULT

    test-one-level-set RESULT

    echo "${RESULT[@]}"
}

test-one-level-set() {
    local "$1" && wickIndirectArray "$1" one two three
}

@test "lib/wickIndirect: one level" {
    [ "$(test-one-level)" == "one two three" ]
}

test-conflicting-variables() {
    local AAA

    AAA="before"
    test-conflicting-variables-set1 AAA
    echo "${AAA[@]}"
}

test-conflicting-variables-set1() {
    local AAA

    AAA=(wrong data)
    test-conflicting-variables-set2 AAA
    AAA=("${AAA[@]}" "+set1")
    local "$1" && wickIndirectArray "$1" "${AAA[@]}"
}

test-conflicting-variables-set2() {
    local AAA

    AAA="set2-before"
    local "$1" && wickIndirectArray "$1" set2a set2b
}

@test "lib/wickIndirect: conflicting variables" {
    [ "$(test-conflicting-variables)" == "set2a set2b +set1" ]
}
