(module
  (memory (export "memory") 1) ;; 1 page of 64KiB memory

  ;; utility function for incrementing an i32
  ;; usage: (set_local $x (call $increment (get_local $x)))
  (func $increment (param $value i32) (result i32)
    (i32.add
      (get_local $value)
      (i32.const 1)
    )
  )

  (func $f64_ma
    (export "f64_ma")
    (param $ts_ptr i32)
    (param $ts_len i32)
    (param $order i32)
    (param $center i32)
    ;; result: how2 declare array return type?

    ;; locals
    (local $odd f32)
    (local $mov_avg_ptr i32) ;; how2 setup the return array?

    ;; 3-fold branch on odd and center 2 setup the remaining locals (loop vars)

    ;; loop body...
  )
)
