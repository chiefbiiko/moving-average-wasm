(module
  (memory (export "memory") 1) ;; 1 page of 64KiB memory

  (func $f64_ma
    (export "f64_ma")

    (param $in_ptr i32)
    (param $in_len i32)
    (param $order i32)
    (param $center i32)
    (param $out_ptr i32)

    (local $odd i32)
    (local $win_sum f64)
    (local $win_head i32)
    (local $win_tail i32)
    (local $side_len i32)
    (local $loop_end i32)

    ;; check if order is odd
    (set_local $odd (i32.and (get_local $order) (i32.const 1)))

    ;; 3-fold branch on odd and center 2 init the remaining locals (loop vars)
    (if (i32.eqz (get_local $odd) (i32.const 1))
      (then ;; if odd

      )
      (else
        (if (i32.eqz (get_local $center) (i32.const 0))
          (then ;; if even && !center

          )
          (else ;; if even && center

          )
        )
      )
    )

    ;; make sure $out_ptr points to where it should before looping

    ;; loop body...
  )
)
