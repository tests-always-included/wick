#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect-array"
    . "$WICK_DIR/lib/wick-string-split"
}

@test "lib/wick-string-split: empty string" {
    local DEST

    DEST="did not update destination value"
    wickStringSplit DEST ""
    [[ $(set | grep ^DEST=) == 'DEST=([0]="")' ]]
}

@test "lib/wick-string-split: delimeter does not match" {
    local DEST

    DEST="did not update destination value"
    wickStringSplit DEST "abcd" "e"
    [[ $(set | grep ^DEST=) == 'DEST=([0]="abcd")' ]]
}

@test "lib/wick-string-split: defaults to space" {
    local DEST

    DEST="did not update destination value"
    wickStringSplit DEST "a b c"
    [[ $(set | grep ^DEST=) == 'DEST=([0]="a" [1]="b" [2]="c")' ]]
}

@test "lib/wick-string-split: empty positions" {
    local DEST

    DEST="did not update destination value"
    wickStringSplit DEST "|a||b|" "|"
    [[ $(set | grep ^DEST=) == 'DEST=([0]="" [1]="a" [2]="" [3]="b" [4]="")' ]]
}

@test "lib/wick-string-split: multi-character delimeter" {
    local DEST

    DEST="did not update destination value"
    wickStringSplit DEST "cowMOOOOcow" "MOOOO"
    [[ $(set | grep ^DEST=) == 'DEST=([0]="cow" [1]="cow")' ]]
}
