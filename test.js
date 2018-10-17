const tape = require('tape')
const ma = require('./index.js')

tape('odd-ordered moving average', t => {
  t.same(
    ma([ 1, 2, 3, 4, 5 ], 3),
    [ null, 2, 3, 4, null ],
    '3-ma of seq 12345'
  )
  t.end()
})

tape('even-ordered moving average (automatically ceiled and centered)', t => {
  t.same(
    ma([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ], 4),
    [ null, null, 3, 4, 5, 6, 7, 8, null, null ],
    '4-ma of seq 12345678910 (auto ceil + center)'
  )
  t.end()
})
