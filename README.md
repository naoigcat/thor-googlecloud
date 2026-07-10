# Manager of Google Cloud storage

Manage files of Google Cloud storage.

## Requirements

-   Docker
-   mise
-   Google Cloud Account

## Usage

### Normalize filenames to NFC

Run below command.

```sh
mise run normalize [project] [bucket]
```

### Upload files

Move files to `uploads/[bucket]` directory and run below command.

```sh
mise run upload [project]
```

## Development

1.  Run command to start a container.

    ```sh
    docker compose build
    docker compose run --rm app /bin/bash
    ```

2.  Edit files.

3.  Run command to stop the container.

    ```sh
    docker compose down
    ```

## Author

naoigcat

## License

MIT
