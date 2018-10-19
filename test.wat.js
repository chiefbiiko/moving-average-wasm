const tape = require('tape')
const wasm = require('./index.wat.js')()

tape('f64_sum', t => { // dev test
  const arr = [ 1, 2, 3, 4, 5 ]

  var f64 = new Float64Array(wasm.exports.memory.buffer)
  for (var i = 0; i < arr.length; i++) f64[i] = arr[i]

  const sum = wasm.exports.f64_sum(0, 5 * 8)
  t.equal(sum, 15, 'sum is 15')
  t.end()
})
