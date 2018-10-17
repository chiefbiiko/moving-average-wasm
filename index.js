/* hyndman's forecast::ma for reference
ma <- function(x, order, centre=TRUE) {
  if (abs(order - round(order)) > 1e-8) {
    stop("order must be an integer")
  }

  if (order %% 2 == 0 && centre) { # centred and even
    w <- c(0.5, rep(1, order - 1), 0.5) / order
  } else { # odd or not centred
    w <- rep(1, order) / order
  }

  return(filter(x, w))
}
*/

const isNumArr = x => Array.isArray(x) && x.every(y => typeof y === 'number')

const sum = (arr, start, end) => {
  for (var sum = 0, i = start; i < end; i++) sum += arr[i]
  return sum
}

// if order is even, the observations averaged will include one more
// observation from the future than the past, and will be centered
const ma = (ts, order, center = true) => {
  if (!isNumArr(ts)) throw TypeError('ts (time series) is not a number array')
  if (order % 1) throw TypeError('order is not an integer')
  if (order < 2) throw TypeError('order is not greater than 1')

  const odd = order % 2
  const win_len = odd ? order : order + 1
  const ts_len = ts.length
  const side_len = (win_len - 1) / 2
  const loop_end = ts_len - side_len
  const mov_avg = Array(ts_len).fill(null)

  if (!odd && center) { // even and center
    for (
      let win_sum = sum(ts, 0, win_len) - (ts[0] / 2) - (ts[order] / 2),
        i = side_len,
        win_head = 0,
        win_tail = win_len - 1;
      i < loop_end;
      i++, win_head++, win_tail++
    ) {
      mov_avg[i] = win_sum / order
      win_sum += (
        (ts[win_tail] / 2) + (ts[win_tail + 1] / 2)
        - (ts[win_head] / 2) - (ts[win_head + 1] / 2)
      )
    }
  } else if (!odd) { // even
    for (
      let win_sum = sum(ts, 0, order),
        i = side_len - 1,
        win_head = 0,
        win_tail = order - 1;
      i < loop_end;
      i++, win_head++, win_tail++
    ) {
      mov_avg[i] = win_sum / order
      win_sum += (ts[win_tail + 1] - ts[win_head])
    }
  } else if (odd) { // odd
    for (
      let win_sum = sum(ts, 0, win_len),
        i = side_len,
        win_head = 0,
        win_tail = win_len - 1;
      i < loop_end;
      i++, win_head++, win_tail++
    ) {
      mov_avg[i] = win_sum / win_len
      win_sum += (ts[win_tail + 1] - ts[win_head])
    }
  }

  return mov_avg
}

module.exports = ma
