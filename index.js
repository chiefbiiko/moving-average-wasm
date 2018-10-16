/* hyndman's ma function from pkg forecast
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
module.exports = function ma (series, order) {
  if (!isNumArr(series)) throw TypeError('series is not a number array')
  if (order % 1) throw TypeError('order is not an integer')
  if (order < 2) throw TypeError('order is not greater than 1')
  const odd = order % 2
  const window_len = odd ? order : order + 1
  // const weight_len = odd ? order : order + 1
  // const weight = Array(weight_len)
  // if (odd) {
  //   for (let v = 1 / order, i = 0; i < weight_len; i++) weight[i] = v
  // } else {
  //   const tail = weight_len - 1
  //   weight[0] = weight[tail] = .5 / order
  //   for (let v = 1 / order, i = 1; i < tail; i++) weight[i] = v
  // }
  const series_len = series.length

  // BELOW: assumes odd ordered ma!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  const ma = Array(series_len)
  const side_len = (window_len - 1) / 2
  const loop_end = series_len - side_len

  // let cur_sum = sum(series, i - side_len, i + side_len)
  var cur_sum = sum(series, 0, window_len)
  for (let i = side_len, sub = 0 add = window_len; i < loop_end; i++, sub++, add++) {
    ma[i] = cur_sum / window_len
    cur_sum -= series[sub]
    cur_sum += series[add]
  }
  return ma
}
