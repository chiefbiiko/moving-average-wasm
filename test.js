const tape = require('tape')
const ma = require('/index.js')

tape('odd-ordered moving averages', t => {
  t.same(
    ma([ 1, 2, 3, 4, 5 ], 3),
    [ undefined, 2, 3, 4, undefined ],
    '3-ma of seq 12345'
  )
})
