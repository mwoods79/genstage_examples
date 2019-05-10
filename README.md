# GenstageExample

Used to talk about strategies and use cases for genstage at Jax.Ex meetup.

## Setup Instructions:
```bash
git clone https://github.com/MichaelDimmitt/genstage_examples.git &&
cd genstage_examples/ &&
mix deps.get &&
mix ecto.create &&
mix ecto.migrate &&
iex -S mix
```
open http://localhost:4001/factorial?number=10

## Using posix commands as background jobs to send 10 requests to localhost.
```bash
for i in {1..10}; do curl -s http://localhost:4001/factorial?number=$i &>/dev/null & done &>/dev/null &&
jobs
```
