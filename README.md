# Info
The base hashrate used is from a ryzen 1700, which means the calculated share is skewed towards cpus.

# Usage
Use a coin ticker to only fetch the share of a single coin
```
./supply XMR
```
Don't pass anything and a list with all the coins will be printed.
Tabulate the output, sorting by the highest share:
```
./supply.sh | sort -k 3# Usage
Use a coin ticker to only fetch the share of a single coin
```
./supply.sh XMR
```
Don't pass anything and a list with all the coins will be printed.

Tabulate the output, sorting by the highest share:
```
./supply.sh | sort -k 2 -n -r | column -t
```
 -n -r | column -t
```
