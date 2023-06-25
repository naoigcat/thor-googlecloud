# Manager of Google Cloud storage

Manage files of Google Cloud storage.

## Requirements

-   Docker
-   Google Cloud Account

## Usage

### Normalize filenames to NFC

Run below command.

```sh
docker compose build
docker compose run --rm app normalize [project] [bucket]
docker compose down
```

### Upload files

Move files to `uploads/[bucket]` directory and run below command.

```sh
docker compose build
docker compose run --rm app upload [project]
docker compose down
```

## Development

1.  Run command to start a container.

    ```sh
    docker compose build
    docker compose run --rm --entrypoint /bin/bash app
    ```

2.  Edit entrypoint.thor.

3.  Run command to stop the container.

    ```sh
    docker compose down
    ```

## Author

naoigcat

## License

MIT
