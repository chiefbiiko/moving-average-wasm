(module
  (memory (export "memory") 1) ;; 1 page of 64KiB memory

  (func $f64_sum
    (export "f64_sum") ;; just an utility; exclude from final exports
    (param $ptr i32) ;; start byte index in memory
    (param $end i32) ;; end byte index in memory (exclusive)
    (result f64)

    (local $sum f64)

    (block $end_loop
      (loop $start_loop
        (br_if $end_loop (i32.eq (get_local $ptr) (get_local $end)))

        ;; sum += memory[ptr]
        (set_local $sum (f64.add (get_local $sum) (f64.load (get_local $ptr))))

        ;; ptr += 8
        (set_local $ptr (i32.add (get_local $ptr) (i32.const 8)))

        (br $start_loop)
      )
    )

    (get_local $sum)
  )

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

    ;; odd = order & 1 ;; check if order is odd
    (set_local $odd (i32.and (get_local $order) (i32.const 1)))

    ;; 3-fold branch on odd and center 2 init the remaining locals (loop vars)
    (if (i32.eq (get_local $odd) (i32.const 1))
      (then ;; if odd



      )
      (else
        (if (i32.eqz (get_local $center))
          (then ;; if even && !center

            ;;(set_local $win_sum ())

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
