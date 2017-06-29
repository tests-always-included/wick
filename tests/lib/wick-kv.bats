#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-argument-string"
    . "$WICK_DIR/lib/wick-debug"
    . "$WICK_DIR/lib/wick-hex"
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-is-var-set"
    . "$WICK_DIR/lib/wick-kv-get"
    . "$WICK_DIR/lib/wick-kv-init"
    . "$WICK_DIR/lib/wick-kv-is-ready"
    . "$WICK_DIR/lib/wick-kv-is-set"
    . "$WICK_DIR/lib/wick-kv-set"
    . "$WICK_DIR/lib/wick-log"
    . "$WICK_DIR/lib/wick-on-exit"
    . "$WICK_DIR/lib/wick-on-exit-trap"
    . "$WICK_DIR/lib/wick-random-string"
    . "$WICK_DIR/lib/wick-temp-dir"
}

@test "lib/wick-kv-is-ready: Reports false" {
    wickKvIsReady || return 0
    return 1
}

@test "lib/wick-kv-is-ready: Reports success" {
    # Subshell so on-exit trap fires
    (
        wickKvInit
        wickKvIsReady
    )
}

@test "lib/wick-kv-init: Sets WICK_KV_DIR" {
    # Subshell so on-exit trap fires
    (
        wickIsVarSet WICK_KV_DIR && (
            echo "Variable should not be set before initialization" >&2
            return 1
        )

        wickKvInit

        wickIsVarSet WICK_KV_DIR || (
            echo "Variable not set" >&2
            return 1
        )

        [[ -d "$WICK_KV_DIR" ]] || (
            echo "Directory not created" >&2
            return 1
        )
    )
}

@test "lib/wick-kv-is-set: works when vars get set" {
    # Subshell so on-exit trap fires
    (
        wickKvInit
        wickKvIsSet testing && (
            echo "Variable should not yet be set" >&2
            return 1
        )

        wickKvSet testing "any value"
        wickKvIsSet testing || (
            echo "Variable should be set" >&2
            return 1
        )
    )
}

@test "lib/wick-kv-get: Getting an unset value" {
    # Subshell so on-exit trap fires
    (
        local result

        wickKvInit
        result="unchanged"
        wickKvGet result test.key
        [[ "$result" == "" ]]
    )
}

@test "lib/wick-kv-?et: Set and get string" {
    # Subshell so on-exit trap fires
    (
        local result

        wickKvInit
        wickKvSet test.key "a string"
        result="unchanged"
        wickKvGet result test.key
        [[ "$result" == "a string" ]]
    )
}

@test "lib/wick-kv-?et: Set and get whitespace" {
    # Subshell so on-exit trap fires
    (
        local result

        wickKvInit
        wickKvSet test.key $'1\n2\n'
        result="unchanged"
        wickKvGet result test.key
        [[ "$result" == $'1\n2\n' ]]
    )
}
