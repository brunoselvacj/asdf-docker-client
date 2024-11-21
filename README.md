# asdf-docker-client

Docker Client plugin for [asdf](https://github.com/asdf-vm/asdf) version manager

## Install

```shell
asdf plugin add docker-client https://github.com/bruselvacj/asdf-docker-client.git
```

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions.

```shell
# Show plugin help
asdf help docker-client

# List all available versions
asdf list-all docker-client

# Install latest version
asdf install docker-client latest

# Install specific version
asdf install docker-client 27.3.1

# Set a version globally
asdf global docker-client 27.3.1

# Set a version locally
asdf local docker-client 27.3.1

# Show installed versions
asdf list docker-client
```

## Architecture Support

This plugin supports the following architectures:
- x86_64 (amd64)
- arm64 (Apple Silicon)

## Configuration

No additional configuration is needed for this plugin.

## License

See [LICENSE](LICENSE) Bruno Selva
