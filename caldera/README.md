
# Notes

## Cross Compiling Sandcat for ARM
```bash
cd caldera/plugins/sandcat/gocat
env GOOS=linux GOARCH=arm go build -o armedcat32
```