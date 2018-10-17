/*
hyndman's forecast::ma for reference:

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
// observation from the future than the past
const ma = (ts, order, center = true) => {
  if (!isNumArr(ts)) throw TypeError('ts (time series) is not a number array')
  if (order % 1) throw TypeError('order is not an integer')
  if (order < 2) throw TypeError('order is not greater than 1')

  const odd = order % 2
  const ts_len = ts.length
  const mov_avg = Array(ts_len).fill(null)

  if (!odd && center) { // even and center
    for (
      let win_sum = sum(ts, 0, order + 1) - (ts[0] / 2) - (ts[order] / 2),
        win_head = 0,
        win_tail = order,
        side_len = order / 2,
        i = side_len,
        loop_end = ts_len - side_len;
      i < loop_end;
      i++, win_sum += (
        (ts[win_tail++] / 2) + (ts[win_tail] / 2)
        - (ts[win_head++] / 2) - (ts[win_head] / 2)
      )
    ) {
      mov_avg[i] = win_sum / order
    }
  } else if (!odd) { // even
    for (
      let win_sum = sum(ts, 0, order),
        win_head = 0,
        win_tail = order - 1,
        side_len = order / 2,
        i = side_len - 1,
        loop_end = ts_len - side_len;
      i < loop_end;
      i++, win_sum += (ts[++win_tail] - ts[win_head++])
    ) {
      mov_avg[i] = win_sum / order
    }
  } else { // odd
    for (
      let win_sum = sum(ts, 0, order),
        win_head = 0,
        win_tail = order - 1,
        side_len = win_tail / 2, // actually (order - 1) / 2, saved for dryness
        i = side_len,
        loop_end = ts_len - side_len;
      i < loop_end;
      i++, win_sum += (ts[++win_tail] - ts[win_head++])
    ) {
      mov_avg[i] = win_sum / order
    }
  }

  return mov_avg
}

module.exports = ma
