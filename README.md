# Usage
Use a coin ticker to only fetch the share of a single coin
```
./supply XMR
```
Don't pass anything and a list with all the coins will be printed.
Tabulate the output, sorting by the highest share:
```
./supply.sh | sort -k 2 -n -r | column -t
```
