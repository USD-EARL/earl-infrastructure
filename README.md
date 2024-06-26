# earl-infrastructure
EARL Infrastructure as Code

# Layout
## caldera
- `caldera-iot` -- git submodule of earl caldera plugin
  - gets copied into the caldera container at runtime by docker compose

# Run

## Initialize
Only needs to be ran once to initialize the environment

1) `emux/build-emux-volume` -- create emux volume and copy files in
2) `emux/build-emux-docker` -- create the emux image (possibly can be done in the compose?)
3) `docker compose up setup` -- Setup ELK containers

## Usage


## Features
- Adversary emulation using MITRE's Caldera tool in a container
- ARM Caldera Sandcat agent
- IoT Caldera plugin for initial Mirai Botnet Adversary Emulation Abilities
- Infrastructure-as-Code lab with one click start
- Network sniffing with Zeek with larges parsed and pipelined into ELK for query and visualization
- Emulated IoT devices using the EMUX project container

## Future Work
- MIPS agent
- C based agent
- Shell agent
- Full Mirai AE
- Attach a USB wifi to the docker network
- Attach USB to ethernet to docker network
- Add physical embedded device for use in network
- host-based logs with sysmon
- sysmon-server

# TODO
- start an agent on the caldera box to act as the "Internet" attacker, 
- so that we can launch attacks from caldera
- make a script to "restart" agent on caldera server in case it goes down
- make a script to auto-start an agent in emux / emux qemu guest
- add script to emux for forwarding QEMU guest to interface
- make script to start up qemu guest automatically, or instructions how to manually
- git-submodule emux at specific commit