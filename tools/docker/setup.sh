docker_setup()
{
		cp ../tools/docker/Dockerfile_${linuxARCH} ../build/Dockerfile
    cd ../build
    docker build -t linux_builder:$linuxARCH -f Dockerfile .
    cd ../targets
}
