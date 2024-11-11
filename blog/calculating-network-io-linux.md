# Using awk to calculate current & cumulative network io in Linux

It seems surprisingly difficult to simply *monitor network traffic* on a Linux machine. In Mac or Windows the Activity Monitor (or equivalent) gives a very convenient read out of the network io. But on the terminal it seems far more complex? 

We were moving several terabytes of data from one cloud service to another, and orchestrated this migration with a dozen rclone processes on a server. So the data had to pass through our server. These processes obviously decided to use different network interfaces, and none of the standard tooling I could find (`nload`, `vnstat` and `ifstat`) had a useful way to aggregate and average that output.

gpt-4o gave me a useful command:

## Command

```bash
awk 'BEGIN {rx_total = 0; tx_total = 0; count = 0} 
{
    if (NR > 1) { 
        rx_current = ($2 - prev_rx) * 8 / 1024 / 1000; 
        tx_current = ($3 - prev_tx) * 8 / 1024 / 1000; 
        rx_total += rx_current; 
        tx_total += tx_current; 
        count++; 
        print "Current -> RX: " rx_current " Mbps, TX: " tx_current " Mbps | Cumulative Avg -> RX: " (rx_total / count) " Mbps, TX: " (tx_total / count) " Mbps"
    } 
    prev_rx = $2; 
    prev_tx = $3; 
}' < <(while true; do 
    awk '/:/ {rx += $2; tx += $10} END {print systime(), rx, tx}' /proc/net/dev; 
    sleep 1; 
done)
```

This gets data from /proc/net/dev, which contains network device statistics for all network interfaces on the system.

## Output

```bash
Current -> RX: 629.627 Mbps, TX: 622.788 Mbps | Cumulative Avg -> RX: 248.934 Mbps, TX: 252.662 Mbps
Current -> RX: 672.702 Mbps, TX: 685.594 Mbps | Cumulative Avg -> RX: 249.076 Mbps, TX: 252.807 Mbps
Current -> RX: 841.485 Mbps, TX: 843.618 Mbps | Cumulative Avg -> RX: 249.273 Mbps, TX: 253.004 Mbps
Current -> RX: 493.836 Mbps, TX: 506.74 Mbps | Cumulative Avg -> RX: 249.355 Mbps, TX: 253.088 Mbps
Current -> RX: 271.716 Mbps, TX: 261.214 Mbps | Cumulative Avg -> RX: 249.362 Mbps, TX: 253.091 Mbps
Current -> RX: 262.509 Mbps, TX: 279.012 Mbps | Cumulative Avg -> RX: 249.367 Mbps, TX: 253.1 Mbps
Current -> RX: 267.209 Mbps, TX: 275.438 Mbps | Cumulative Avg -> RX: 249.373 Mbps, TX: 253.107 Mbps
Current -> RX: 489.213 Mbps, TX: 532.462 Mbps | Cumulative Avg -> RX: 249.453 Mbps, TX: 253.2 Mbps
Current -> RX: 625.308 Mbps, TX: 640.062 Mbps | Cumulative Avg -> RX: 249.578 Mbps, TX: 253.329 Mbps
Current -> RX: 858.792 Mbps, TX: 837.012 Mbps | Cumulative Avg -> RX: 249.78 Mbps, TX: 253.523 Mbps
Current -> RX: 339.77 Mbps, TX: 320.927 Mbps | Cumulative Avg -> RX: 249.81 Mbps, TX: 253.546 Mbps
Current -> RX: 251.283 Mbps, TX: 246.06 Mbps | Cumulative Avg -> RX: 249.811 Mbps, TX: 253.543 Mbps
```

It reads from /proc/net/dev continuously with a while loop. For each iteration, it sums up the received (rx) and transmitted (tx) bytes across all network interfaces, outputs the timestamp and total rx and tx bytes, and the outer awk command then processes this output to calculate current rx and tx rates in Mbps, as well as the cumulative average rx and tx rates in Mbps.

It gets the cumulative average based on the previous cumulative average and some function of the time etc. Precisely:

average = (count + 1) /  (cumulative_total + new_value)

So the only thing in memory is the count and the cumulative_total, which gets constantly updated. The average will then stabilise around the true average as time goes on. 

This is particularly useful since the few times I saw it randomly, network io was anywhere from 20mpbs to 600mbps. I had to get this cumulative average setup and run it for a few hours before I actually knew the average, because the variance in io was quite significant.



