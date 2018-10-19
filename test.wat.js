const tape = require('tape')
const wasm = require('./index.wat.js')()
// return console.log(wasm.exports.memory.buffer)

tape('f64_sum', t => {
  const arr = [ 1, 2, 3, 4, 5 ]
  // wasm.exports.memory.set(arr, 0)
  // wasm.exports.memory = new Float64Array(arr)

  var f64 = new Float64Array(wasm.exports.memory.buffer)
  for (var i = 0; i < arr.length; i++) f64[i] = arr[i]

  const sum = wasm.exports.f64_sum(0, 5 * 8)
  t.equal(sum, 15, 'sum is 15')
  t.end()
})
