# How to calculate network io in terminal on Mac

```bash
awk 'BEGIN {rx_total = 0; tx_total = 0; count = 0}
function readBytes(cmd) {
    cmd | getline bytes
    close(cmd)
    return bytes
}
{
    new_rx = readBytes("netstat -ib | grep \"en0\" | awk \047{print $7}\047")
    new_tx = readBytes("netstat -ib | grep \"en0\" | awk \047{print $10}\047")

    if (NR > 1) {
        rx_rate = (new_rx - old_rx) * 8 / 1024 / 1024  # Convert to Mbps
        tx_rate = (new_tx - old_tx) * 8 / 1024 / 1024
        rx_total += rx_rate
        tx_total += tx_rate
        count++

        printf "\rCurrent -> RX: %.2f Mbps, TX: %.2f Mbps | Avg -> RX: %.2f Mbps, TX: %.2f Mbps",
              rx_rate, tx_rate, (rx_total/count), (tx_total/count)
    }
    old_rx = new_rx
    old_tx = new_tx
    fflush()
}' < <(while true; do echo; sleep 1; done)
```

