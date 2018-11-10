(module

  ;; (func $i32_debug (import "imports" "i32_debug") (param i32))
  ;; (func $f64_debug (import "imports" "f64_debug") (param f64))

  (memory (export "memory") 1) ;; 1 page of 64KiB memory

  (global $F64_BYTE_LEN i32 (i32.const 8))

  (func $f64_sum
    (export "f64_sum") ;; just an utility; exclude from final exports
    (param $ptr i32) ;; start byte index in memory
    (param $end i32) ;; end byte index in memory (exclusive)
    (result f64)

    (local $sum f64)

    (block $end_loop
      (loop $start_loop
        (br_if $end_loop
          (i32.eq (get_local $ptr) (get_local $end)))

        ;; sum += memory[ptr]
        (set_local $sum
          (f64.add (get_local $sum) (f64.load (get_local $ptr))))

        ;; ptr += 8
        (set_local $ptr
          ;; (i32.add (get_local $ptr) (i32.const 8)))
          (i32.add (get_local $ptr) (get_global $F64_BYTE_LEN)))

        (br $start_loop)
      )
    )

    (get_local $sum)
  )

  (func $f64_ma
    (export "f64_ma")
    ;; input array lives @ memory[0..in_arr_byte_length]
    ;; output array lives @ memory[in_arr_byte_length..2*in_arr_byte_length]

    ;; all size related params and locals are bytewise
    (param $in_ptr i32)
    (param $in_byte_len i32) ;; byteLength
    (param $order i32)
    (param $center i32)
    (param $out_ptr i32)

    (local $odd i32)
    (local $win_sum f64)
    (local $win_head_byte i32)
    (local $win_tail_byte i32)
    (local $side_byte_len i32)
    (local $loop_end_byte i32)
    (local $f64_order f64)
    (local $win_byte_len i32)

    ;; odd = order & 1 ;; check if order is odd
    (set_local $odd
      (i32.and (get_local $order) (i32.const 1)))

    (set_local $f64_order
      (f64.convert_u/i32 (get_local $order)))

    ;; 3-fold branch on odd and center 2 init the remaining locals (loop vars)
    (if (i32.eq (get_local $odd) (i32.const 1))
      (then ;; if odd


        (set_local $win_byte_len
          (i32.mul (get_local $order) (get_global $F64_BYTE_LEN)))

        ;; win_sum = sum(memory[in_ptr..order]) ;; calc initial window sum
        (set_local $win_sum
          (call $f64_sum (get_local $in_ptr) (get_local $win_byte_len)))

        ;; win_head_byte = in_ptr ;; set window head to start of input arr
        (set_local $win_head_byte (get_local $in_ptr))

        ;; win_tail_byte = win_byte_len - 8 + in_ptr ;; set window tail to end of input arr
        (set_local $win_tail_byte
          (i32.add
            (i32.sub (get_local $win_byte_len) (get_global $F64_BYTE_LEN))
            (get_local $in_ptr)))

        ;; side_byte_len = (win_tail_byte - in_ptr) / 2 ;; calc window side len
        (set_local $side_byte_len
          (i32.div_u
            (i32.sub
              (get_local $win_tail_byte) ;; actually: order - 8 + in_ptr
              (get_local $in_ptr))
            (i32.const 2)))

        ;; in_ptr += side_byte_len
        (set_local $in_ptr
          (i32.add (get_local $in_ptr) (get_local $side_byte_len)))

        ;; loop_end = in_byte_len - side_byte_len + in_ptr
        (set_local $loop_end_byte
          (i32.add
            (i32.sub
              (get_local $in_byte_len)
              (get_local $side_byte_len))
            (get_local $in_ptr)))

      )
      (else
        (if (i32.eqz (get_local $center))
          (then ;; if even && !center
            ;; TODO
          )
          (else ;; if even && center
            ;; TODO
          )
        )
      )
    )

    ;; make sure $out_ptr points to where it should before looping
    (set_local $out_ptr
      (i32.add (get_local $in_ptr) (get_local $in_byte_len)))

    ;; loop body...
    (block $end_loop
      (loop $start_loop
        (br_if $end_loop
          (i32.eq (get_local $out_ptr) (get_local $loop_end_byte)))

        ;; mov_avg[i] = win_sum / f64_order
        (f64.store
          (get_local $out_ptr)
          (i32.const 8)
          (f64.div (get_local $win_sum) (get_local $f64_order)))

        ;; in_ptr += 8 ;; WRONG!
        ;;(set_local $in_ptr (i32.add (get_local $in_ptr) (i32.const 8)))
        ;; out_ptr += 8
        (set_local $out_ptr
          (i32.add (get_local $out_ptr) (get_global $F64_BYTE_LEN)))

        ;; ;; 3-fold branch on odd and center 2 calc win_sum
        (if (i32.eq (get_local $odd) (i32.const 1))
          (then ;; if odd

            ;; win_tail_byte += 8
            (set_local $win_tail_byte
              (i32.add (get_local $win_tail_byte) (get_global $F64_BYTE_LEN)))
            ;; win_sum += (ts[win_tail_byte] - ts[win_head_byte])
            (set_local $win_sum
              (f64.add
                (get_local $win_sum)
                (f64.sub
                  ;; BUG: RuntimeError: memory access out of bounds
                  (f64.load offset=0 align=8 (get_local $win_tail_byte))
                  (f64.load offset=0 align=8 (get_local $win_head_byte))
                )))
            ;; win_head_byte += 8
            (set_local $win_head_byte
              (i32.add (get_local $win_head_byte) (get_global $F64_BYTE_LEN)))

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
