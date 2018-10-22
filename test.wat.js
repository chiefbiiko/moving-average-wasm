const tape = require('tape')
const wasm = require('./index.wat.js')()

tape('f64_sum', t => { // dev test
  const arr = [ 1, 2, 3, 4, 5 ]

  new Float64Array(wasm.exports.memory.buffer).set(arr, 0, arr.length)

  const sum = wasm.exports.f64_sum(0, arr.length * 8)
  t.equal(sum, 15, 'sum is 15')
  t.end()
})

tape.skip('f64_ma - odd-ordered moving average', t => {
  const arr = [ 1, 2, 3, 4, 5 ]
  const exp = new Float64Array([ null, 2, 3, 4, null ])

})
