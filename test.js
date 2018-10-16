const tape = require('tape')
const ma = require('./index.js')

tape('odd-ordered moving averages', t => {
  t.same(
    ma([ 1, 2, 3, 4, 5 ], 3),
    [ null, 2, 3, 4, null ],
    '3-ma of seq 12345'
  )
  t.end()
})

tape('even-ordered moving averages (automatically ceiled and centered)', t => {
  t.same(
    ma([ 1, 2, 3, 4, 5 ], 2),
    [ null, 1.3333333333333333, 2, 2.6666666666666665, null ],
    '2-ma of seq 12345 (auto ceil + center)'
  )
  t.end()
})
