function (wasm) {
  const in_arr = [ 1, 2, 3, 4, 5 ]
  const in_ptr = 0
  const in_arr_byte_length = in_arr.length * 8

  new Float64Array(wasm.exports.memory.buffer).set(in_arr, in_ptr, in_arr.length)
  const out_arr = new Float64Array(wasm.exports.memory.buffer, in_arr_byte_length, in_arr.length)

  wasm.exports.f64_ma(
    in_ptr, // in_arr ptr into memory
    in_arr_byte_length, // in_arr byteLength
    3,  // order
    0, // center
    in_ptr + in_arr_byte_length // out_arr ptr into memory
  )

  assertSameArr(out_arr, new Float64Array([ null, 2, 3, 4, null ]))

  function assertSameArr (a, b) {
    if (a.length !== b.length) throw AssertionError('unequal lengths')
    for (var i = 0; i < a.length; i++) {
      if (a[i] !== b[i]) throw AssertionError('unequal item')
    }
  }
}
