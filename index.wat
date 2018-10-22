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

        ;; win_sum = sum(memory[in_ptr..order]) ;; calc initial window sum
        (set_local $win_sum
          (call $f64_sum
            (get_local $in_ptr)
            (get_local $order)))
        ;; win_head = in_ptr ;; set window head to start of input arr
        (set_local $win_head (get_local $in_ptr))
        ;; win_tail = order - 1 + in_ptr ;; set window tail to end of input arr
        (set_local $win_tail
          (i32.add
            (get_local $in_ptr)
            (i32.sub
              (get_local $order)
              (i32.const 1))))
        ;; side_len = win_tail - in_ptr / 2 ;; calc window side len
        (set_local $side_len
          (i32.div_u
            (i32.sub
              (get_local $win_tail) ;; actually: order - 1 + in_ptr
              (get_local $in_ptr))
            (i32.const 2)))
        ;; in_ptr += side_len
        (set_local $in_ptr (i32.add (get_local $in_ptr) (get_local $side_len)))
        ;; loop_end = in_len - side_len + in_ptr
        (set_local $loop_end
          (i32.add
            (i32.sub
              (get_local $in_len)
              (get_local $side_len))
            (get_local $in_ptr)))

      )
      (else
        (if (i32.eqz (get_local $center))
          (then ;; if even && !center

          )
          (else ;; if even && center

          )
        )
      )
    )

    ;; make sure $out_ptr points to where it should before looping
    (set_local $out_ptr
      (i32.add
        (get_local $in_ptr)
        (get_local $in_len)))

    ;; loop body...
    (block $end_loop
      (loop $start_loop
        (br_if $end_loop (i32.eq (get_local $in_ptr) (get_local $loop_end)))

        ;; TODO: mov_avg[i] = win_sum / order
        (f64.store
          (get_local $out_ptr)
          (f64.div
            (get_local $win_sum)
            (get_local $order)))

        ;; in_ptr += 8
        (set_local $in_ptr (i32.add (get_local $in_ptr) (i32.const 8)))
        ;; out_ptr += 8
        (set_local $out_ptr (i32.add (get_local $out_ptr) (i32.const 8)))

        ;; ;; 3-fold branch on odd and center 2 calc win_sum
        (if (i32.eq (get_local $odd) (i32.const 1))
          (then ;; if odd

            ;; win_tail += 8
            (set_local $win_tail (i32.add (get_local $win_tail) (i32.const 8)))
            ;; win_sum += (ts[win_tail] - ts[win_head])
            (set_local $win_sum
              (i32.add
                (get_local $win_sum)
                (i32.sub
                  (f64.load (get_local $win_tail))
                  (f64.load (get_local $win_head)))))
            ;; win_head += 8
            (set_local $win_head (i32.add (get_local $win_head) (i32.const 8)))

          )
          (else
            (if (i32.eqz (get_local $center))
              (then ;; if even && !center

              )
              (else ;; if even && center

              )
            )
          )
        )
        ;; ;;

        (br $start_loop)
      )
    )

  )
)
