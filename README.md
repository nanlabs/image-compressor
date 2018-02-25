
# image-compressor
A simple bulk recursive dockerized image compressor using ImageMagick.

Compress image directories or docker volumes recursively using ImageMagick in a safety way, since it keeps the modified images in a backup directory.
It allows to set the compression arguments used to process the files. Besides that it also allows to set the minimum compression expected rate to consider an image as compressed.

## How to use it:

 1. Clone the repository
 2. Move to the cloned dir `cd image-compressor` 
 3. Build the image using `docker build -t image-compressor .`
 4. Edit the `.env` file if needed
 5. Run the container mounting the image directories as follows
  ``` 
docker run \
	--env-file=.env \
	-v <source directory or docker volume>:/source \
	-v <target directory or docker volume>:/target \
	-v <backup directory or docker volume>:/backup \
    --rm image-compressor
```

## Enviroment variables accepted:

| Variable | Description | Default value|
| -- | -- | -- |
| JPG_COMPRESSION_ARGS | JPG arguments description | "-strip -quality 90 -interlace JPEG -colorspace sRGB" | 
| PNG_COMPRESSION_ARGS | PNG ImageMagick arguments description | "-strip" | 
| EXPECTED_COMPRESSION_RATIO | Minimum ratio to consider an image compression useful | 15 | 




**Notes**: both, the `target`  and the `backup` directories mounting are optionals, and only needed if you want to preserve that information
