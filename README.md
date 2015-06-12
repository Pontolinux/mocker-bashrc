mocker-bashrc
===========

The .bashrc file for Mocker.

## Shortcut commands for Mocker

### Show the usage

```
$ mocker --help
```

or

```
$ mocker -h
```

### Update Mocker

```
$ mocker update
```

### Run a new Mocker container using "pontolinux/mocker:latest"

```
$ mocker run
```

### Run a new Mocker container and assign a name

```
$ mocker run --name <containername>
```

or

```
$ mocker run --name=<containername>
```

e.g.

```
$ mocker run --name magento
```

### Use another docker image to run a new Mocker container

```
$ mocker run <image>
```

e.g.

```
$ mocker run mocker/mocker:centos6
```

### Use another docker image to run a new Mocker container and assign a name

```
$ mocker run --name <containername> <image>
```

or

```
$ mocker run --name=<containername> <image>
```

e.g.

```
$ mocker run --name magento mocker/mocker:centos6
```

### Remove all containers and files

```
$ mocker destroy
```
