const tape = require('tape')
const wasm = require('./index.wat.js')({
  imports: {
     i32_debug: x => console.log(`i32: ${x}`),
     f64_debug: x => console.log(`f64: ${x}`)
  }
})

tape('f64_sum', t => { // dev test
  const arr = [ 1, 2, 3, 4, 5 ]

  new Float64Array(wasm.exports.memory.buffer).set(arr, 0, arr.length)

  const sum = wasm.exports.f64_sum(0, arr.length * 8)
  t.equal(sum, 15, 'sum is 15')
  t.end()
})

tape.only('f64_ma - odd-ordered moving average', t => {
  const in_arr = [ 1, 2, 3, 4, 5 ]
  const in_ptr = 0
  const in_arr_byte_length = in_arr.length * 8

  new Float64Array(wasm.exports.memory.buffer).set(in_arr, in_ptr, in_arr.length)
  const out_arr = new Float64Array(wasm.exports.memory.buffer, in_arr_byte_length, in_arr.length)
  // const exp = new Float64Array([ null, 2, 3, 4, null ])

  t.same(out_arr, new Float64Array([ 0, 0, 0, 0, 0 ]), 'same typed arr')

  wasm.exports.f64_ma(
    in_ptr, // in_arr ptr into memory
    in_arr_byte_length, // in_arr byteLength
    3,  // order
    0, // center
    in_ptr + in_arr_byte_length // out_arr ptr into memory
  )

  t.same(out_arr, new Float64Array([ null, 2, 3, 4, null ]), 'same typed arr')

  t.end()
})
